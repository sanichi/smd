class Contact < ApplicationRecord
  include Constrainable
  include Pageable

  MAX_EMAIL = 80
  MAX_NAME = 30

  before_validation :normalize_attributes

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, length: { maximum: MAX_EMAIL }, uniqueness: true
  validates :first_name, :last_name, length: { maximum: MAX_NAME }, presence: true

  scope :by_email,      -> { order(:email) }
  scope :by_first_name, -> { order(:first_name, :last_name) }
  scope :by_last_name,  -> { order(:last_name, :first_name) }
  scope :by_latest,     -> { order(created_at: :desc) }

  def self.search(matches, params, path, opt={})
    if sql = cross_constraint(params[:query], %w{email first_name last_name})
      matches = matches.where(sql)
    end
    case params[:order]
    when "email"      then matches = matches.by_email
    when "first_name" then matches = matches.by_first_name
    when "last_name"  then matches = matches.by_last_name
    else                   matches = matches.by_latest
    end
    paginate(matches, params, path, opt)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def full
    "#{name} <#{email}>"
  end

  def self.list
    self.by_email.all.map(&:full).join(", ")
  end

  private

  def normalize_attributes
    email&.gsub!(/\s+/, "")&.downcase!
    first_name&.squish!
    last_name&.squish!
  end
end
