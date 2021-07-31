class PagesController < ApplicationController
  def index
    @sample = Painting.sample
  end

  def exhibitions
    @sample = Painting.sample
  end
end
