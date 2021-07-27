class Painting < ApplicationRecord
  include Constrainable
  include Pageable

  MAX_TITLE = 50
  MAX_SIZE = 200
  MIN_SIZE = 5
  GALLERY = 1..4
  MEDIA = %w/mm wc chcr pstl oil/

  before_validation :normalize_attributes

  validates :filename, length: { maximum: MAX_TITLE }, uniqueness: true, format: { with: /\A[a-z0-9]+(_[a-z0-9]+)*\z/ }
  validates :title,    length: { maximum: MAX_TITLE }, uniqueness: true, presence: true
  validates :width, :height, numericality: { only_integer: true, greater_than_or_equal_to: MIN_SIZE, less_than_or_equal_to: MAX_SIZE }, allow_nil: true
  validates :media, inclusion: { in: MEDIA }
  validates :gallery, inclusion: { in: GALLERY }

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

  def image_path(web: false, tn: false)
    path = "#{tn ? 'thumbnails' : 'images'}/#{filename}.jpg"
    if web
      "/" + path
    else
      Rails.root + "public" + path
    end
  end

  def image_dimensions(tn: false)
    return nil unless %x|file #{image_path(tn: tn)}|.match(/JPEG.*, ([1-9]\d{2,3}x[1-9]\d{2,3}),/)
    $1
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
        target = painting.image_path
        unless target.exist? && target.size == source.size
          FileUtils.cp(source, target)
          copies += 1
        end
      else
        raise "image #{source} does not exist"
      end
      source = Rails.root + "public" + p.src(true)
      if source.exist?
        target = painting.image_path(tn: true)
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
