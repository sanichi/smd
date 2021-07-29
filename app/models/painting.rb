class Painting < ApplicationRecord
  include Constrainable
  include Pageable

  GALLERY = 1..4
  MEDIA = %w/mm wc chcr pstl oil/
  PIXELS = 100..1000
  PRICE = 10..10000
  SIZE = 5..200
  STARS = 0..5
  THUMB = 100
  TITLE = 50

  before_validation :normalize_attributes

  validates :filename, length: { maximum: TITLE }, uniqueness: true, format: { with: /\A[a-z0-9]+(_[a-z0-9]+)*\z/ }
  validates :title,    length: { maximum: TITLE }, uniqueness: true, presence: true
  validates :gallery,  inclusion: { in: GALLERY }
  validates :media,    inclusion: { in: MEDIA }
  validates :stars,    inclusion: { in: STARS }
  validates :price,    inclusion: { in: PRICE }, allow_nil: true
  validates :width,    inclusion: { in: SIZE }, allow_nil: true
  validates :height,   inclusion: { in: SIZE }, allow_nil: true

  validate :check_images

  scope :by_size,    -> { order(Arel.sql("COALESCE(width,0) * COALESCE(height,0) DESC")) }
  scope :by_price,   -> { order(Arel.sql("COALESCE(price,0) DESC")) }
  scope :by_updated, -> { order(updated_at: :desc) }
  scope :by_stars,   -> { order(stars: :desc) }
  scope :by_title,   -> { order(:title) }

  def self.search(matches, params, path, opt={})
    if sql = cross_constraint(params[:query], %w{title filename})
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
    format = short ? "%d⨯%d" : "%d ⨯ %d cm"
    format % [width, height]
  end

  def pounds
    price.present? ? "£#{price}" : ""
  end

  def dimensions(short=false)
    format = short ? "%d⨯%d" : "%d ⨯ %d px"
    format % [image_width, image_height]
  end

  def proportionate_width
    (image_width.to_f * THUMB / image_height.to_f).round
  end

  def image_path(web: true, tn: false)
    path = "#{tn ? 'thumbnails' : 'images'}/#{Rails.env.test? ? 'test' : filename}.jpg"
    if web
      "/" + path
    else
      Rails.root + "public" + path
    end
  end

  def last_updated
    updated_at.strftime("%Y-%m-%d")
  end

  private

  def normalize_attributes
    filename&.squish!
    title&.squish!
    self.width = width.to_i
    self.width = nil if width == 0
    self.height = height.to_i
    self.height = nil if height == 0
  end

  def get_dimensions(tn: false)
    return [0, 0] unless %x|file #{image_path(web: false, tn: tn)}|.match(/JPEG.*, ([1-9]\d{2,3})x([1-9]\d{2,3}),/)
    [$1.to_i, $2.to_i]
  end

  def check_images
    if filename.present?
      w, h = get_dimensions
      if w == 0 || h == 0
        errors.add(:filename, "main image doesn't exist yet or is the wrong type")
      elsif w <= PIXELS.first || w > PIXELS.last
        errors.add(:filename, "main image width (#{w}) should be > #{PIXELS.first} and ≤ #{PIXELS.last}")
      elsif h <= PIXELS.first || h > PIXELS.last
        errors.add(:filename, "main image height (#{w}) should be > #{PIXELS.first} and ≤ #{PIXELS.last}")
      else
        self.image_width = w
        self.image_height = h
      end
      w, h = get_dimensions(tn: true)
      if w == 0 || h == 0
        errors.add(:filename, "thumnail image doesn't exist yet or is the wrong type")
      elsif w != THUMB || h != THUMB
        errors.add(:filename, "thumnail image should be #{THUMB}x#{THUMB}")
      end
    end
  end

  def self.migrate
    puts "before: #{count}"
    destroy_all
    ActiveRecord::Base.connection.execute("ALTER SEQUENCE paintings_id_seq RESTART WITH 1");
    copies = 0
    gallery = 0
    total = 0
    index = 0
    ApplicationHelper::PICTURES.each do |p|
      width, height = nil, nil
      if p.cm != "00x00" && p.cm.match(/\A(\d\d)x(\d\d)/)
        width = $1.to_i
        height = $2.to_i
      end
      media =
        case p.type
        when "pt" then "pstl"
        when "ol" then "oil"
        when "cc" then "chcr"
        else p.type
        end
      if p.g != gallery
        gallery = p.g
        total = ApplicationHelper::PICTURES.select{ |p| p.g == gallery }.size
        index = 0
      else
        index += 1
      end
      stars = p.s == 0 ? 0 : 1 + (4.0 * (total - index).to_f / total.to_f).round
      painting = create!(
        title: p.name,
        filename: p.file,
        gallery: p.g,
        media: media,
        price: p.price,
        sold: p.sold?,
        stars: stars,
        width: width,
        height: height,
      )
      source = Rails.root + "public" + p.src
      if source.exist?
        target = painting.image_path(web: false)
        unless target.exist? && target.size == source.size
          FileUtils.cp(source, target)
          copies += 1
        end
      else
        raise "image #{source} does not exist"
      end
      source = Rails.root + "public" + p.src(true)
      if source.exist?
        target = painting.image_path(web: false, tn: true)
        unless target.exist? && target.size == source.size
          FileUtils.cp(source, target)
          copies += 1
        end
      else
        raise "image #{source} does not exist"
      end
    end
    puts "after: #{count}, copies: #{copies}"
  end
end
