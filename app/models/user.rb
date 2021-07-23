class User < ApplicationRecord
  MAX_NAME = 20
  MIN_PASSWORD = 8

  has_secure_password

  before_validation :normalize_attributes

  validates :name, length: { maximum: MAX_NAME }, presence: true, uniqueness: true
  validates :password, length: { minimum: MIN_PASSWORD }, allow_nil: true

  default_scope { order(:name) }

  def guest?
    false
  end

  private

  def normalize_attributes
    name&.squish!
  end
end
