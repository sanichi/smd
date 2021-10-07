class ContactsController < ApplicationController
  load_and_authorize_resource

  def index
    @contacts = Contact.search(@contacts, params, contacts_path)
  end

  def create
    subscription = params[:commit] == t("contact.subscribe")
    if @contact.save
      if subscription
        flash[:info] = t("contact.messages.subscribed", value: @contact.full)
        redirect_to root_path
      else
        redirect_to @contact
      end
    else
      failure @contact
      if subscription
        render :subscribe
      else
        render :new
      end
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

  def subscribe
    @contact = Contact.new
  end

  private

  def resource_params
    params.require(:contact).permit(:email, :first_name, :last_name)
  end
end
