class ContactsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource only: [:subscribe, :unsubscribe]

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
        render :new, status: :unprocessable_entity
      end
    end
  end

  def update
    if @contact.update(resource_params)
      redirect_to @contact
    else
      failure @contact
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path
  end

  def remove
    @contact.destroy
  end

  def subscribe
    @contact = Contact.new
  end

  def unsubscribe
    unless params[:email].nil?
      email = params[:email].gsub(/\s+/, "").downcase
      if email.present?
        if email.match?(URI::MailTo::EMAIL_REGEXP)
          contact = Contact.find_by(email: email)
          if contact
            contact.destroy
            flash[:info] = t("contact.messages.unsubscribed", value: email)
            redirect_to root_path
          else
            flash.now[:alert] = t("contact.messages.unrecognized", value: email)
            render :unsubscribe
          end
        else
          flash.now[:alert] = t("contact.messages.invalid")
          render :unsubscribe
        end
      else
        flash.now[:alert] = t("contact.messages.blank")
        render :unsubscribe
      end
    end
  end

  private

  def resource_params
    params.require(:contact).permit(:email, :first_name, :last_name)
  end
end
