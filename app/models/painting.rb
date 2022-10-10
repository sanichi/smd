require 'csv'

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
  PRINT = 5..1000
  SIZE = 5..200
  STARS = 0..5
  TITLE = 50

  attr_accessor :image, :tmp1, :tmp2

  belongs_to :exhibit, optional: true, inverse_of: :paintings, counter_cache: true

  before_validation :normalize_attributes

  validates :title,    length: { maximum: TITLE }, uniqueness: { case_sensitive: false, message: "is already used for another painting" }, presence: true
  validates :gallery,  inclusion: { in: GALLERY }
  validates :media,    inclusion: { in: MEDIA }
  validates :stars,    inclusion: { in: STARS }
  validates :price,    inclusion: { in: PRICE, message: "%{value} is not valid" }, allow_nil: true
  validates :print,    inclusion: { in: PRINT, message: "%{value} is not valid" }, allow_nil: true
  validates :width,    inclusion: { in: SIZE,  message: "%{value} is not valid" }, allow_nil: true
  validates :height,   inclusion: { in: SIZE,  message: "%{value} is not valid" }, allow_nil: true

  validate :check_image
  validate :check_archived

  after_save :move_images

  scope :by_size,    -> { order(Arel.sql("COALESCE(width,0) * COALESCE(height,0) DESC")) }
  scope :by_price,   -> { order(Arel.sql("COALESCE(price,0) DESC, COALESCE(print,0) DESC")) }
  scope :by_print,   -> { order(Arel.sql("COALESCE(print,0) DESC, COALESCE(price,0) DESC")) }
  scope :by_updated, -> { order(updated_at: :desc) }
  scope :by_stars,   -> { order(stars: :desc) }
  scope :by_title,   -> { order(:title) }

  def self.search(matches, params, path, opt={})
    matches = matches.includes([:exhibit])
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
      when "sale"
        matches = matches.where(sale: true)
    end
    case params[:order]
    when "price"   then matches = matches.by_price
    when "print"   then matches = matches.by_print
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

  def pounds(show_sale: false)
    mark = sale && show_sale ? I18n.t("symbol.sale") : ""
    price.present? ? "£#{price}#{mark}" : ""
  end

  def print_pounds
    print.present? ? "£#{print}" : ""
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
      "/" + path + "?v=#{version}"
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

  def self.compare(file)
    results = OpenStruct.new
    begin
      raise "No CSV file supplied" if file.nil?
      raise "App error: file parameter is wrong type (#{file.class})" unless file.is_a?(ActionDispatch::Http::UploadedFile)
      raise "Please export your numbers file to CSV and then upload that" if file.original_filename =~ /\.numbers\z/i
      raise "Filename (#{file.original_filename}) doesn‘t look like its CSV" unless file.original_filename =~ /\.csv\z/i
      raise "File content type (#{file.content_type}) doesn‘t look like its CSV" unless file.content_type == "text/csv"
      results.rows = CSV.parse(file.read, encoding: "UTF-8")
      results.items = filter(results.rows)
      raise "No paintings detected, something is wrong" if results.items.empty?
      results.dups = duplicates(results.items)
      raise "Duplicate titles detected: please correct and try again" unless results.dups.empty?
      results.paintings = Painting.where(archived: false).to_a
      match(results)
      unmatched(results)
    rescue => e
      results.error = e.message
    end
    results
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

  def check_archived
    if archived? && !exhibit.nil?
      errors.add(:archived, I18n.t("painting.errors.archived"))
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
          FileUtils.chmod(0664, pmt)
          Rails.logger.info("IMAGE move #{pmt}|#{pmt.file?}")
        end
        update_column(:version, version + 1)
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

  def self.filter(rows)
    rows.select do |row|
      row.length == 11
    end.each_with_index.map do |row, i|
      row.push(i+1)
      row
    end.select do |row|
      row[1].is_a?(String) &&
      row[1].present? &&
      row[1].match?(/[a-z]/i) &&
      row[1] != "Title" &&
      !row[1].match?(/\bprint\b/i)
    end.map do |row|
      p = OpenStruct.new
      p.title = row[1].squish
      p.row = row[11]
      p.price = row[5].to_i
      p.price = nil if p.price == 0
      if row[2] =~ /(\d+)cm\s*x\s*(\d+)cm/
        p.width = $1.to_i
        p.height = $2.to_i
      end
      p.sold = (row[3].present? && row[3].match?(/\bsold\b/i)) || row[6].present? || row[7].present?
      p
    end
  end

  def self.duplicates(items)
    hash = Hash.new { |h,k| h[k] = [] }
    items.each do |item|
      hash[item.title.downcase].push(item.row)
    end
    hash.delete_if {|k,v| v.length == 1}
    hash
  end

  def self.match(results)
    results.items.each do |item|
      i = results.paintings.index { |p| p.title.downcase == item.title.downcase }
      item.painting = results.paintings[i] if i
    end
  end

  def self.unmatched(results)
    results.unmatched = (results.paintings - results.items.map{|i| i.painting}.compact).sort_by{|p| p.title}
  end
end
