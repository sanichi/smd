require 'rails_helper'

describe Content do
  let(:admin)    { create(:user, admin: true) }
  let(:user)     { create(:user, admin: false) }
  let(:data)     { build(:content) }
  let!(:content) { create(:content) }

  context "admin" do
    before(:each) do
      login admin
      click_link t("content.contents")
    end

    it "create" do
      expect(page).to have_css "a", text: t("content.new")
      click_link t("content.new")

      fill_in t("content.name"), with: data.name
      fill_in t("content.markdown"), with: data.markdown
      click_button t("save")

      expect(page).to have_title data.name
      expect(Content.count).to eq 2
      t = Content.find_by(name: data.name)
      expect(t.markdown).to eq data.markdown
    end

    it "edit" do
      click_link content.name
      click_link t("edit")
      expect(page).to have_css "label", text: t("content.name")
      fill_in t("content.name"), with: data.name
      fill_in t("content.markdown"), with: data.markdown
      click_button t("save")

      expect(page).to have_title data.name
      expect(Content.count).to eq 1
      t = Content.first
      expect(t.name).to eq data.name
      expect(t.markdown).to eq data.markdown
    end

    it "delete" do
      click_link content.name
      click_link t("edit")
      expect(page).to have_css "a", text: t("delete")
      click_link t("delete")

      expect(page).to have_title t("content.contents")
      expect(Content.count).to eq 0
    end
  end

  context "users" do
    before(:each) do
      login user
      click_link t("content.contents")
    end

    it "edit (but not name)" do
      old_name = content.name

      click_link content.name
      click_link t("edit")
      expect(page).to_not have_css "label", text: t("content.name")
      fill_in t("content.markdown"), with: data.markdown
      click_button t("save")

      expect(page).to have_title old_name
      expect(Content.count).to eq 1
      t = Content.first
      expect(t.name).to eq old_name
      expect(t.markdown).to eq data.markdown
    end

    it "can't create" do
      expect(page).to_not have_css "a", text: t("content.new")
      visit new_content_path
      expect_forbidden page
    end

    it "can't delete" do
      click_link content.name
      click_link t("edit")
      expect(page).to_not have_css "a", text: t("delete")
    end
  end

  context "guests" do
    before(:each) do
      visit root_path
    end

    it "can't index" do
      expect(page).to_not have_css "a", text: t("content.contents")
      visit contents_path
      expect_forbidden page
    end

    it "can't view" do
      visit content_path content
      expect_forbidden page
    end

    it "can't create" do
      visit new_content_path
      expect_forbidden page
    end
  end
end
