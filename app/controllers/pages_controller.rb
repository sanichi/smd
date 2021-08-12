class PagesController < ApplicationController
  def index
    @markdown = markdown "Welcome"
    @sample = Painting.sample
  end

  def exhibitions
    @markdown = markdown "Exhibitions"
    @sample = Painting.sample
  end

  def available
    @paintings = Painting.where("sold = 'f' OR print IS NOT NULL").where(archived: false).by_title
  end

  private

  def markdown(name)
    Content.find_by(name: name)&.markdown || ""
  end
end
