class Painting < ApplicationRecord
  include Constrainable
  include Pageable

  MAX_TITLE = 50
  MAX_SIZE = 200
  MIN_SIZE = 5
  MAX_PIXELS = 1000
  MIN_PIXELS = 100
  TN_PIXELS = 100
  GALLERY = 1..4
  MEDIA = %w/mm wc chcr pstl oil/

  before_validation :normalize_attributes

  validates :filename, length: { maximum: MAX_TITLE }, uniqueness: true, format: { with: /\A[a-z0-9]+(_[a-z0-9]+)*\z/ }
  validates :title,    length: { maximum: MAX_TITLE }, uniqueness: true, presence: true
  validates :width, :height, numericality: { only_integer: true, greater_than_or_equal_to: MIN_SIZE, less_than_or_equal_to: MAX_SIZE }, allow_nil: true
  validates :media, inclusion: { in: MEDIA }
  validates :gallery, inclusion: { in: GALLERY }

  validate :check_images

  scope :by_size,    -> { order(Arel.sql("COALESCE(width,0) * COALESCE(height,0) DESC")) }
  scope :by_title,   -> { order(:title) }
  scope :by_updated, -> { order(updated_at: :desc) }

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
    case params[:sold]
      when "sold"
        matches = matches.where(sold: true)
      when "available"
        matches = matches.where(sold: false)
    end
    case params[:order]
    when "updated"
      matches = matches.by_updated
    when "size"
      matches = matches.by_size
    else
      matches = matches.by_title
    end
    paginate(matches, params, path, opt)
  end

  def size(short=false)
    return "" unless width.present? && height.present?
    format = short ? "%dx%d" : "%d x %d cm"
    format % [width, height]
  end

  def dimensions(short=false)
    format = short ? "%dx%d" : "%d x %d px"
    format % [image_width, image_height]
  end

  def proportionate_width
    (image_width.to_f * TN_PIXELS / image_height.to_f).round
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
      elsif w <= MIN_PIXELS || w > MAX_PIXELS
        errors.add(:filename, "main image width (#{w}) should be > #{MIN_PIXELS} and ≤ #{MAX_PIXELS}")
      elsif h <= MIN_PIXELS || h > MAX_PIXELS
        errors.add(:filename, "main image height (#{w}) should be > #{MIN_PIXELS} and ≤ #{MAX_PIXELS}")
      else
        self.image_width = w
        self.image_height = h
      end
      w, h = get_dimensions(tn: true)
      if w == 0 || h == 0
        errors.add(:filename, "thumnail image doesn't exist yet or is the wrong type")
      elsif w != TN_PIXELS || h != TN_PIXELS
        errors.add(:filename, "thumnail image should be #{TN_PIXELS}x#{TN_PIXELS}")
      end
    end
  end

  def self.migrate
    puts "before: #{count}"
    destroy_all
    copies = 0
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
      painting = create!(
        title: p.name,
        filename: p.file,
        width: width,
        height: height,
        media: media,
        sold: p.sold?,
        gallery: p.g,
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
