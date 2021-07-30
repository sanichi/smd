class PaintingsController < ApplicationController
  load_and_authorize_resource

  def index
    @paintings = Painting.search(@paintings.where(archived: false), params, paintings_path, per_page: 10)
  end

  def archive
    @paintings = @paintings.where(archived: true).by_title
  end

  def create
    if @painting.save
      redirect_to @painting
    else
      failure @painting
      render :new
    end
  end

  def update
    if @painting.update(resource_params)
      redirect_to @painting
    else
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
    params.require(:painting).permit(:archived, :filename, :gallery, :height, :media, :price, :sold, :stars, :title, :width)
  end
end
