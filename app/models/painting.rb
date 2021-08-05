class Painting < ApplicationRecord
  include Constrainable
  include Pageable

  GALLERY = 1..4
  IMAGE_MAX = 900
  IMAGE_MIN = 200
  IMAGE_QUALITY = 80
  IMAGE_RESIZE = 600
  IMAGE_THUMB = 100
  MEDIA = %w/mm wc chcr pstl oil/
  PIXELS = 100..1000
  PRICE = 10..10000
  SIZE = 5..200
  STARS = 0..5
  TITLE = 50

  attr_accessor :image, :tmp1, :tmp2

  before_validation :normalize_attributes

  validates :title,    length: { maximum: TITLE }, uniqueness: { message: "is already used for another painting" }, presence: true
  validates :gallery,  inclusion: { in: GALLERY }
  validates :media,    inclusion: { in: MEDIA }
  validates :stars,    inclusion: { in: STARS }
  validates :price,    inclusion: { in: PRICE, message: "%{value} is not valid" }, allow_nil: true
  validates :width,    inclusion: { in: SIZE,  message: "%{value} is not valid" }, allow_nil: true
  validates :height,   inclusion: { in: SIZE,  message: "%{value} is not valid" }, allow_nil: true

  validate :check_image

  after_save :move_images

  scope :by_size,    -> { order(Arel.sql("COALESCE(width,0) * COALESCE(height,0) DESC")) }
  scope :by_price,   -> { order(Arel.sql("COALESCE(price,0) DESC")) }
  scope :by_updated, -> { order(updated_at: :desc) }
  scope :by_stars,   -> { order(stars: :desc) }
  scope :by_title,   -> { order(:title) }

  def self.search(matches, params, path, opt={})
    if sql = cross_constraint(params[:query], %w{title})
      matches = matches.where(sql)
    end
    if MEDIA.include?(params[:media])
      matches = matches.where(media: params[:media])
    end
    if GALLERY.include?(g = params[:gallery].to_i)
      matches = matches.where(gallery: g)
    end
    if params[:stars].present? && STARS.include?(s = params[:stars].to_i)
      matches = matches.where(stars: s)
    end
    if params[:price]&.squish == "0"
      matches = matches.where(price: nil)
    elsif sql = numerical_constraint(params[:price], :price)
      matches = matches.where(sql)
    end
    case params[:sold]
      when "sold"
        matches = matches.where(sold: true)
      when "available"
        matches = matches.where(sold: false)
    end
    case params[:order]
    when "price"   then matches = matches.by_price
    when "size"    then matches = matches.by_size
    when "stars"   then matches = matches.by_stars
    when "updated" then matches = matches.by_updated
    else                matches = matches.by_title
    end
    paginate(matches, params, path, opt)
  end

  def size(short=false)
    return "" unless width.present? && height.present?
    format = short ? "%d⨯%d" : "%d⨯%dcm"
    format % [width, height]
  end

  def pounds
    price.present? ? "£#{price}" : ""
  end

  def dimensions(short=false)
    format = short ? "%d⨯%d" : "%d⨯%dpx"
    format % [image_width, image_height]
  end

  def anchor
    "p-#{id}"
  end

  def image_path(web: true, full: true)
    path = "#{Rails.env.test? ? 'test' : 'img'}/#{full ? 'F' : 'T'}#{id}.jpg"
    if web
      "/" + path
    else
      Rails.root + "public" + path
    end
  end

  def last_updated
    updated_at.strftime("%Y-%m-%d")
  end

  def self.sample
    where(archived: false).where("stars > 0").sample
  end

  def cleanup
    tmp1.unlink if tmp1
    tmp2.unlink if tmp2
  end

  private

  def normalize_attributes
    title&.squish!
    self.width = width.to_i
    self.width = nil if width == 0
    self.height = height.to_i
    self.height = nil if height == 0
  end

  def check_image
    if image && !errors.any?
      type, w, h = identify(image.path)
      if type.nil?
        errors.add(:image, I18n.t("painting.errors.format"))
      elsif type == "HEIC"
        errors.add(:image, I18n.t("painting.errors.heic"))
      elsif w < IMAGE_MIN || h < IMAGE_MIN
        errors.add(:image, I18n.t("painting.errors.small"))
      else
        w, h = convert(w, h)
        if w == 0 || h == 0
          errors.add(:image, I18n.t("painting.errors.convert"))
        else
          unless thumbnail
            errors.add(:image, I18n.t("painting.errors.thumbnail"))
          else
            self.image_width = w
            self.image_height = h
          end
        end
      end
    else
      errors.add(:image, I18n.t("painting.errors.blank")) if new_record?
    end
  end

  def identify(file)
    if run("identify #{file}", true).match(/(HEIC|JPEG|PNG|GIF) ([1-9]\d*)x([1-9]\d*)/)
      [$1, $2.to_i, $3.to_i]
    else
      [nil, 0, 0]
    end
  end

  def convert(w, h)
    self.tmp1 = Tempfile.new
    resize = ""
    if w > IMAGE_MAX || h > IMAGE_MAX
      if w > h
        h = (IMAGE_RESIZE * h.to_f / w.to_f).round
        w = IMAGE_RESIZE
      else
        w = (IMAGE_RESIZE * w.to_f / h.to_f).round
        h = IMAGE_RESIZE
      end
      resize = "-resize '#{w}x#{h}!'"
    end
    quality = "-quality #{IMAGE_QUALITY}"
    run("convert #{image.path} #{resize} #{quality} jpg:#{tmp1.path}", true)
    type, p, q = identify(tmp1.path)
    type == "JPEG" && w == p && h == q ? [w, h] : [0, 0]
  end

  def thumbnail
    self.tmp2 = Tempfile.new
    wxh = "#{IMAGE_THUMB}x#{IMAGE_THUMB}"
    run("convert #{tmp1.path} -thumbnail '#{wxh}^' -gravity center -extent #{wxh} jpg:#{tmp2.path}", true)
    type, w, h = identify(tmp2.path)
    type == "JPEG" && w == IMAGE_THUMB && h = IMAGE_THUMB
  end

  def move_images
    begin
      if tmp1 && tmp2
        [true, false].each do |full|
          tmp = full ? tmp1 : tmp2
          pmt = image_path(web: false, full: full)
          FileUtils.cp(tmp.path, pmt)
          Rails.logger.info("IMAGE move #{pmt}|#{pmt.file?}")
        end
      else
        Rails.logger.error("IMAGE absent tmp1|#{tmp1 ? 1 : 0}||tmp2#{tmp2 ? 1 : 0}")
      end
    rescue => e
      Rails.loggger.error(e.message)
    ensure
      cleanup
    end
  end

  def run(cmd, log=false)
    out = %x|#{cmd} 2>&1|
    Rails.logger.info "IMAGE #{cmd} -> #{out}" if log
    out
  end
end
