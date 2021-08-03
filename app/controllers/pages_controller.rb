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
    @me = %x|whoami 2>&1|
    @which = %x|which convert 2>&1|
    @jpg = Rails.root + "public" + "img" + "jpg.jpg"
    @jpg_c = %x|convert /home/sanichi/img.jpg -resize '100x100!' #{@jpg} 2>&1|
    @jpg_i = %x|identify #{@jpg} 2>&1|
    @png = Rails.root + "public" + "img" + "png.jpg"
    @png_c = %x|convert /home/sanichi/img.png -resize '100x100!' #{@png} 2>&1|
    @png_i = %x|identify #{@png} 2>&1|
    @gif = Rails.root + "public" + "img" + "gif.jpg"
    @gif_c = %x|convert /home/sanichi/img.png -resize '100x100!' #{@gif} 2>&1|
    @gif_i = %x|identify #{@gif} 2>&1|
  end

  private

  def markdown(name)
    Content.find_by(name: name)&.markdown || ""
  end
end
