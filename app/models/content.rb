class Content < ApplicationRecord
  include Remarkable

  NAME = 20

  before_validation :normalize_attributes

  validates :name, length: { maximum: NAME }, uniqueness: true, presence: true
  validates :markdown, presence: true

  def html
    to_html(markdown)
  end

  private

  def normalize_attributes
    name&.squish!
    markdown&.lstrip!
    markdown&.rstrip!
    markdown&.gsub!(/([^\S\n]*\n){2,}[^\S\n]*/, "\n\n")
  end
end
