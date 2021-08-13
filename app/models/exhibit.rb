class Exhibit < ApplicationRecord
  include Constrainable
  include Pageable

  MAX_NAME = 30
  MAX_LOCATION = 25
  URL_PREFIX = /\Ahttps?:\/\//

  has_many :paintings, inverse_of: :exhibit

  before_validation :normalize_attributes

  validates :link, format: { with: URL_PREFIX }, allow_nil: true
  validates :location, length: { maximum: MAX_LOCATION }, presence: true
  validates :name, length: { maximum: MAX_NAME }, presence: true, uniqueness: { scope: :location }

  scope :by_count, -> { order(paintings_count: :desc, name: :asc) }
  scope :by_name,  -> { order(:name) }
  scope :current,  -> { where("paintings_count > 0").by_name }
  scope :previous, -> { where("paintings_count = 0 OR previous = 't'").by_name }

  def self.search(matches, params, path, opt={})
    matches = matches.by_count
    if sql = cross_constraint(params[:query], %w{name location})
      matches = matches.where(sql)
    end
    paginate(matches, params, path, opt)
  end

  def domain
    domain = link
    if domain.present?
      domain.sub!(URL_PREFIX, "")
      domain.sub!(/\Awww\./, "")
      domain.sub!(/\/.*/, "")
    end
    domain
  end

  private

  def normalize_attributes
    link&.gsub!(/\s+/, "")
    self.link = nil if link.blank?
    location&.squish!
    name&.squish!
  end
end
