class Contact < ApplicationRecord
  include Constrainable
  include Pageable

  MAX_EMAIL = 80
  MAX_NAME = 30

  before_validation :normalize_attributes

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, length: { maximum: MAX_EMAIL }, uniqueness: true
  validates :first_name, :last_name, length: { maximum: MAX_NAME }, presence: true

  scope :by_email, -> { order(:email) }
  scope :by_first, -> { order(:first_name, :last_name) }
  scope :by_last,  -> { order(:last_name, :first_name) }

  def self.search(matches, params, path, opt={})
    if sql = cross_constraint(params[:query], %w{email first_name last_name})
      matches = matches.where(sql)
    end
    case params[:order]
    when "email"      then matches = matches.by_email
    when "first_name" then matches = matches.by_first
    when "last_name"  then matches = matches.by_last
    else                   matches = matches.by_email
    end
    paginate(matches, params, path, opt)
  end

  def name
    "#{first_name} #{last_name}"
  end

  private

  def normalize_attributes
    email&.gsub!(/\s+/, "")&.downcase!
    first_name&.squish!
    last_name&.squish!
  end
end
