require 'rails_helper'

describe Contact do
  let(:user)      { create(:user, admin: false) }
  let(:data)      { build(:contact) }
  let!(:contact)  { create(:contact) }

  context "users" do
    before(:each) do
      login user
      click_link t("contact.contacts")
    end

    it "create" do
      click_link t("contact.new")

      fill_in t("contact.email"), with: data.email
      fill_in t("contact.first_name"), with: data.first_name
      fill_in t("contact.last_name"), with: data.last_name
      click_button t("save")

      expect(page).to have_title data.name
      expect(Contact.count).to eq 2
      c = Contact.find_by(email: data.email)
      expect(c.first_name).to eq data.first_name
      expect(c.last_name).to eq data.last_name
    end

    it "edit" do
      click_link contact.email
      click_link t("edit")
      fill_in t("contact.first_name"), with: data.first_name
      fill_in t("contact.last_name"), with: data.last_name
      click_button t("save")

      expect(page).to have_title data.name
      expect(Contact.count).to eq 1
      c = Contact.first
      expect(c.first_name).to eq data.first_name
      expect(c.last_name).to eq data.last_name
    end

    it "delete" do
      click_link contact.email
      click_link t("edit")
      click_link t("delete")

      expect(page).to have_title t("contact.contacts")
      expect(Contact.count).to eq 0
    end
  end

  context "guests" do
    before(:each) do
      visit root_path
    end

    it "can‘t index" do
      expect(page).to_not have_css "#admin a", text: t("contact.contacts")
      visit contacts_path
      expect_forbidden page
    end

    it "can‘t view" do
      visit contact_path contact
      expect_forbidden page
    end

    it "can‘t create" do
      visit new_contact_path
      expect_forbidden page
    end
  end
end
