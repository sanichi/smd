class PagesController < ApplicationController
  def available
    @paintings = Painting.where("sold = 'f' OR print IS NOT NULL").where(archived: false).includes([:exhibit]).by_title
  end

  def env
    vers = ActiveRecord::Base.connection.execute('select version();').values[0][0] rescue "oops"
    @postgres_version = vers.match(/PostgreSQL (1[4-8]\.\d+)/)? $1 : "not found"
    @host = ENV["HOSTNAME"] || `hostname`.chop.sub(".local", "")
  end

  def exhibitions
    @markdown = markdown "Exhibitions"
    @sample = Painting.sample
    @current = Exhibit.current.to_a
    @previous = Exhibit.previous.to_a
  end

  def index
    @markdown = markdown "Welcome"
    @sample = Painting.sample
  end

  def sale
    @paintings = Painting.where(archived: false, sale: true, sold: false).includes([:exhibit]).by_title
    @markdown = markdown "Sale"
  end

  private

  def markdown(name)
    Content.find_by(name: name)&.markdown || ""
  end
end
