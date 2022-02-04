require 'rails_helper'

describe User do
  let!(:admin) { create(:user, admin: true) }
  let!(:user)  { create(:user, admin: false) }
  let!(:otpu)  { create(:user, admin: false, otp_required: true) }
  let(:data)   { build(:user, admin: false) }

  context "admin" do
    before(:each) do
      login admin
      click_link t("user.users")
    end

    it "counts" do
      expect(page).to have_title t("user.users")
      expect(User.where(admin: false).count).to eq 2
      expect(User.where(admin: true).count).to eq 1
    end

    it "create, login" do
      click_link t("user.new")

      fill_in t("user.name"), with: data.name
      fill_in t("user.password"), with: data.password
      uncheck t("otp.required")
      click_button t("save")

      expect(page).to have_title data.name
      expect(User.where(admin: false).count).to eq 3
      u = User.find_by(name: data.name)
      expect(u.password).to be_nil
      expect(u.password_digest).to be_present
      expect(u.admin).to eq false
      expect(u.otp_required).to eq false
      expect(u.otp_secret).to be_nil
      expect(u.last_otp_at).to be_nil

      click_link t("session.sign_out", name: admin.name)

      click_link t("session.sign_in")
      fill_in t("user.name"), with: u.name
      fill_in t("user.password"), with: data.password
      click_button t("session.sign_in")

      click_link t("session.sign_out", name: u.name)
    end

    it "create, otp, login" do
      click_link t("user.new")

      fill_in t("user.name"), with: data.name
      fill_in t("user.password"), with: data.password
      check t("otp.required")
      click_button t("save")

      expect(page).to have_title data.name
      expect(User.where(admin: false).count).to eq 3
      u = User.find_by(name: data.name)
      expect(u.password).to be_nil
      expect(u.password_digest).to be_present
      expect(u.admin).to eq false
      expect(u.otp_required).to eq true
      expect(u.otp_secret).to be_nil
      expect(u.last_otp_at).to be_nil

      click_link t("session.sign_out", name: admin.name)

      click_link t("session.sign_in")
      fill_in t("user.name"), with: u.name
      fill_in t("user.password"), with: data.password
      click_button t("session.sign_in")

      expect(page).to have_title t("otp.new")

      fill_in t("otp.otp"), with: otp_attempt
      click_button t("otp.submit")

      click_link t("session.sign_out", name: u.name)
    end

    it "edit" do
      click_link user.name
      click_link t("edit")
      fill_in t("user.name"), with: data.name
      click_button t("save")

      expect(User.where(admin: false, name: data.name).count).to eq 1
    end

    it "delete" do
      click_link user.name
      click_link t("edit")
      click_link t("delete")

      expect(page).to have_title t("user.users")
      expect(User.where(admin: false).count).to eq 1
      expect(User.where(admin: true).count).to eq 1
    end
  end

  context "user" do
    before(:each) do
      login user
    end

    it "log out" do
      expect(page).to_not have_css "a", text: t("session.sign_in")
      click_link t("session.sign_out", name: user.name)
      expect(page).to have_css "a", text: t("session.sign_in")
    end

    it "can‘t index" do
      expect(page).to_not have_css "a", text: t("user.users")
      visit users_path
      expect_forbidden page
    end

    it "can‘t view" do
      visit user_path admin
      expect_forbidden page
    end

    it "can‘t create" do
      expect(page).to_not have_css "a", text: t("user.new")
      visit new_user_path
      expect_forbidden page
    end
  end

  context "otp user" do
    before(:each) do
      login otpu
    end

    it "can log in" do
      expect(page).to have_title t("otp.challenge")

      fill_in t("otp.otp"), with: otp_attempt
      click_button t("otp.submit")

      click_link t("session.sign_out", name: otpu.name)
    end

    it "can‘t use bad otp" do
      expect(page).to have_title t("otp.challenge")

      fill_in t("otp.otp"), with: "123456"
      click_button t("otp.submit")

      expect(page).to have_title t("otp.challenge")
      expect_error(page, t("otp.invalid"))

      fill_in t("otp.otp"), with: otp_attempt
      click_button t("otp.submit")

      click_link t("session.sign_out", name: otpu.name)
    end
  end

  context "guest" do
    before(:each) do
      visit root_path
    end

    it "can‘t index" do
      expect(page).to_not have_css "a", text: t("user.users")
      visit users_path
      expect_forbidden page
    end

    it "can‘t view" do
      visit user_path admin
      expect_forbidden page
    end

    it "can‘t create" do
      expect(page).to_not have_css "a", text: t("user.new")
      visit new_user_path
      expect_forbidden page
    end
  end
end
