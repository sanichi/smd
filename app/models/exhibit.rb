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
  validates :name, length: { maximum: MAX_NAME }, presence: true, uniqueness: true

  default_scope { order(:name) }

  def domain
    domain = link
    if domain.present?
      domain.sub!(URL_PREFIX, "")
      domain.sub!(/\/.*/, "")
    end
    domain
  end

  def self.search(matches, params, path, opt={})
    if sql = cross_constraint(params[:query], %w{name location})
      matches = matches.where(sql)
    end
    paginate(matches, params, path, opt)
  end

  private

  def normalize_attributes
    link&.gsub!(/\s+/, "")
    self.link = nil if link.blank?
    location&.squish!
    name&.squish!
  end
end
