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
      render :new
    end
  end

  def update
    if @exhibit.update(resource_params)
      redirect_to @exhibit
    else
      failure @exhibit
      render :edit
    end
  end

  def destroy
    @exhibit.destroy
    redirect_to exhibits_path
  end

  private

  def resource_params
    params.require(:exhibit).permit(:link, :location, :name, :previous)
  end
end
