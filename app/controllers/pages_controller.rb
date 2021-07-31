class PagesController < ApplicationController
  before_action :get_file, only: [:gallery1, :gallery2, :gallery3, :gallery4]

  def index
    @sample = Painting.sample
  end

  def exhibitions
    @sample = Painting.sample
  end

  def search
    @name = params[:name]
  end

  private

  def get_file
    @file = params[:f]
  end
end
