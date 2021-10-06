class ContactsController < ApplicationController
  load_and_authorize_resource

  def index
    @contacts = Contact.search(@contacts, params, contacts_path)
  end

  def create
    if @contact.save
      redirect_to @contact
    else
      failure @contact
      render :new
    end
  end

  def update
    if @contact.update(resource_params)
      redirect_to @contact
    else
      failure @contact
      render :edit
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path
  end

  private

  def resource_params
    params.require(:contact).permit(:email, :first_name, :last_name)
  end
end
