class ExhibitsController < ApplicationController
  load_and_authorize_resource

  def index
    @exhibits = Exhibit.search(@exhibits, params, exhibits_path)
  end

  def create
    if @exhibit.save
      redirect_to @exhibit
    else
      failure @exhibit
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @exhibit.update(resource_params)
      redirect_to @exhibit
    else
      failure @exhibit
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @exhibit.destroy
    redirect_to exhibits_path
  end

  def remove
    @exhibit.paintings.delete_all
    @exhibit.update_column(:previous, true)
    redirect_to @exhibit
  end

  private

  def resource_params
    params.require(:exhibit).permit(:link, :location, :name, :previous)
  end
end
