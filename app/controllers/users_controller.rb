class UsersController < ApplicationController
  load_and_authorize_resource

  def create
    if @user.save
      redirect_to @user
    else
      failure @user
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @user.update(resource_params)
      redirect_to @user
    else
      failure @user
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path
  end

  private

  def resource_params
    params.require(:user).permit(:name, :password, :otp_required)
  end
end
