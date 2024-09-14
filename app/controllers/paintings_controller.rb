class PaintingsController < ApplicationController
  load_and_authorize_resource

  def index
    @paintings = Painting.search(@paintings.where(archived: false), params, paintings_path)
  end

  def gallery
    @g = params[:g].to_i
    @g = Painting::GALLERY.first unless Painting::GALLERY.include?(@g)
    @paintings = Painting.where(gallery: @g).where(archived: false).includes([:exhibit]).by_stars
  end

  def archive
    @paintings = @paintings.where(archived: true).includes([:exhibit]).by_title
  end

  def create
    if @painting.save
      redirect_to @painting
    else
      @painting.cleanup
      failure @painting
      render :new
    end
  end

  def update
    if @painting.update(resource_params)
      redirect_to @painting
    else
      @painting.cleanup
      failure @painting
      render :edit
    end
  end

  def destroy
    @painting.destroy
    redirect_to paintings_path
  end

  private

  def resource_params
    params.require(:painting).permit(:archived, :exhibit_id, :gallery, :height, :image, :media, :note, :price, :print, :sale, :sold, :stars, :title, :width)
  end
end
