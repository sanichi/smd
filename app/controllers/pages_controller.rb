class PagesController < ApplicationController
  before_action :get_file, only: [:gallery1, :gallery2, :gallery3, :gallery4]

  def index
    @names = ApplicationHelper::PICTURES.map(&:name).sort
  end

  def search
    @name = params[:name]
  end

  private

  def get_file
    @file = params[:f]
  end
end
