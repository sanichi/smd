class ContentsController < ApplicationController
  load_and_authorize_resource

  def create
    if @content.save
      redirect_to @content
    else
      failure @content
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @content.update(resource_params)
      redirect_to @content
    else
      failure @content
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @content.destroy
    redirect_to contents_path
  end

  private

  def resource_params
    permitted = [:markdown]
    permitted.push :name if current_user.admin?
    params.require(:content).permit(*permitted)
  end
end
