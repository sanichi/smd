class Exhibit < ApplicationRecord
  include Constrainable
  include Pageable

  MAX_NAME = 25
  MAX_LOCATION = 20

  before_validation :normalize_attributes

  validates :link, format: { with: /https?:\/\// }, allow_nil: true
  validates :location, length: { maximum: MAX_LOCATION }, presence: true
  validates :name, length: { maximum: MAX_NAME }, presence: true, uniqueness: true

  default_scope { order(:name) }

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
