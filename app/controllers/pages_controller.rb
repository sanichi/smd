class PagesController < ApplicationController
  def index
    @markdown = markdown "Welcome"
    @sample = Painting.sample
  end

  def exhibitions
    @markdown = markdown "Exhibitions"
    @sample = Painting.sample
  end

  def test
    @me = %x|whoami|
    @which = %x|which convert|
    @jpg = Rails.root + "public" + "img" + "jpg.jpg"
    @jpg_c = %x|convert /tmp/img.jpg -resize '100x100!' #{@jpg}|
    @jpg_i = %x|identify #{@jpg}|
    @png = Rails.root + "public" + "img" + "png.jpg"
    @png_c = %x|convert /tmp/img.png -resize '100x100!' #{@png}|
    @png_i = %x|identify #{@png}|
    @gif = Rails.root + "public" + "img" + "gif.jpg"
    @gif_c = %x|convert /tmp/img.png -resize '100x100!' #{@gif}|
    @gif_i = %x|identify #{@gif}|
  end

  private

  def markdown(name)
    Content.find_by(name: name)&.markdown || ""
  end
end
