class Painting < ApplicationRecord
  include Constrainable
  include Pageable

  MAX_TITLE = 50

  before_validation :normalize_attributes

  validates :filename, length: { maximum: MAX_TITLE }, uniqueness: true, format: { with: /\A[a-z0-9]+(_[a-z0-9]+)*\z/ }
  validates :title,    length: { maximum: MAX_TITLE }, uniqueness: true, presence: true

  scope :by_updated, -> { order(updated_at: :desc) }

  def self.search(matches, params, path, opt={})
    if sql = cross_constraint(params[:query], %w{title filename})
      matches = matches.where(sql)
    end
    case params[:order]
    when "updated"
      matches = matches.by_updated
    else
      matches = matches.order(:title)
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
  end
end
