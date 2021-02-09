class PagesController < ApplicationController
  before_action :get_file, only: [:gallery1, :gallery2, :gallery3, :gallery4]

  private

  def get_file
    @file = params[:f]
  end
end
