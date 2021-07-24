class Painting < ApplicationRecord
  include Constrainable
  include Pageable

  MAX_TITLE = 50
  MAX_SIZE = 200
  MIN_SIZE = 5

  before_validation :normalize_attributes

  validates :filename, length: { maximum: MAX_TITLE }, uniqueness: true, format: { with: /\A[a-z0-9]+(_[a-z0-9]+)*\z/ }
  validates :title,    length: { maximum: MAX_TITLE }, uniqueness: true, presence: true
  validates :width, :height, numericality: { only_integer: true, greater_than_or_equal_to: MIN_SIZE, less_than_or_equal_to: MAX_SIZE }, allow_nil: true

  scope :by_size,    -> { order(Arel.sql("COALESCE(width,0) * COALESCE(height,0) DESC")) }
  scope :by_title,   -> { order(:title) }
  scope :by_updated, -> { order(updated_at: :desc) }

  def self.search(matches, params, path, opt={})
    if sql = cross_constraint(params[:query], %w{title filename})
      matches = matches.where(sql)
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
    ApplicationHelper::PICTURES.each do |p|
      width, height = nil, nil
      if p.cm != "00x00" && p.cm.match(/\A(\d\d)x(\d\d)/)
        width = $1.to_i
        height = $2.to_i
      end
      create!(title: p.name, filename: p.file, width: width, height: height)
    end
    puts "after: #{count}"
  end
end
