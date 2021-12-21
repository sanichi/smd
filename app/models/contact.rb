class Contact < ApplicationRecord
  include Constrainable
  include Pageable

  MAX_EMAIL = 80
  MAX_NAME = 30

  before_validation :normalize_attributes

  validates :email,
    format:     { with: URI::MailTo::EMAIL_REGEXP },
    length:     { maximum: MAX_EMAIL },
    uniqueness: { message: ->(o, d) { I18n.t("contact.messages.duplicate", value: d[:value]) } }
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

  def self.sanitize(name)
    name.to_s.squish.split(" ").map do |name|
      name.gsub!(/[^[A-Za-z]'‘&-]/, "")
      name.gsub!(/'/, "‘")
      name.gsub!(/‘/, "") if name.match?(/‘/) && !name.match?(/\A\w‘\w+\z/)
      name.gsub!(/-/, "") if name.match?(/-/) && !name.match?(/\A\w\w+-\w\w+\z/)
      name.gsub!(/&/, "") if name.match?(/&/) && name != "&"
      original = name.dup
      name.downcase!
      name =
        case name
        when /\A([a-z])\z/
          $1.upcase + "."
        when /\A([a-z])([a-z]+)\z/
          $1.upcase + $2
        when /\A([a-z])‘([a-z])([a-z]*)\z/
          $1.upcase + "‘" + $2.upcase + $3.to_s
        when /\A([a-z])([a-z]+)-([a-z])([a-z]+)\z/
          $1.upcase + $2 + "-" + $3.upcase + $4
        when /\A([a-z])([a-z]+) & ([a-z])([a-z]+)\z/
          $1.upcase + $2 + " & " + $3.upcase + $4
        else
          name.titleize
        end
      name[2] = original[2] if name.match?(/\AMc[a-z]/)
      name[3] = original[3] if name.match?(/\AMac[a-z]/)
      name
    end.join(" ")
  end

  private

  def normalize_attributes
    email&.gsub!(/\s+/, "")&.downcase!
    self.first_name = self.class.sanitize(first_name)
    self.last_name = self.class.sanitize(last_name)
  end
end
