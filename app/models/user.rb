class User < ApplicationRecord
  MAX_NAME = 20
  MIN_PASSWORD = 8
  OTP_ISSUER = "sandradickie.co.uk"
  OTP_TEST_SECRET = "YAJY2UMNXQE4JFTWH4AFZGBE7YOQX3XY"

  has_secure_password

  before_validation :normalize_attributes
  after_update :reset_otp

  validates :name, length: { maximum: MAX_NAME }, presence: true, uniqueness: true
  validates :password, length: { minimum: MIN_PASSWORD }, allow_nil: true

  default_scope { order(:name) }

  def guest? = false

  private

  def normalize_attributes
    name&.squish!
  end

  def reset_otp
    if !otp_required
      update_columns(otp_secret: nil, last_otp_at: nil)
    end
  end
end
