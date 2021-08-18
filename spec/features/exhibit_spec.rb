require 'rails_helper'

describe Exhibit do
  let(:user)      { create(:user, admin: false) }
  let(:data)      { build(:exhibit) }
  let!(:exhibit)  { create(:exhibit) }
  let!(:painting) { create(:painting, archived: false) }

  context "users" do
    before(:each) do
      login user
      within "#admin" do
        click_link t("exhibit.exhibits")
      end
    end

    it "create" do
      click_link t("exhibit.new")

      fill_in t("exhibit.name"), with: data.name
      fill_in t("exhibit.link"), with: data.link
      fill_in t("exhibit.location"), with: data.location
      data.previous ? check(t("exhibit.previous")) : uncheck(t("exhibit.previous"))
      click_button t("save")

      expect(page).to have_title data.name
      expect(Exhibit.count).to eq 2
      t = Exhibit.find_by(name: data.name)
      expect(t.location).to eq data.location
      expect(t.link).to eq data.link
      expect(t.previous).to eq data.previous
    end

    it "edit" do
      click_link exhibit.name
      click_link t("edit")
      fill_in t("exhibit.name"), with: data.name
      fill_in t("exhibit.link"), with: data.link
      fill_in t("exhibit.location"), with: data.location
      data.previous ? check(t("exhibit.previous")) : uncheck(t("exhibit.previous"))
      click_button t("save")

      expect(page).to have_title data.name
      expect(Exhibit.count).to eq 1
      t = Exhibit.first
      expect(t.name).to eq data.name
      expect(t.location).to eq data.location
      expect(t.link).to eq data.link
      expect(t.previous).to eq data.previous
    end

    it "delete" do
      click_link exhibit.name
      click_link t("edit")
      click_link t("delete")

      expect(page).to have_title t("exhibit.exhibits")
      expect(Exhibit.count).to eq 0
    end

    it "delete with painting" do
      expect(exhibit.paintings).to eq []
      expect(exhibit.paintings_count).to eq 0
      expect(painting.exhibit).to eq nil

      click_link t("painting.paintings")
      click_link painting.title
      click_link t("edit")
      select exhibit.name, from: t("exhibit.exhibit")
      click_button t("save")

      exhibit.reload
      painting.reload
      expect(exhibit.paintings).to eq [painting]
      expect(exhibit.paintings_count).to eq 1
      expect(painting.exhibit).to eq exhibit

      click_link exhibit.name
      click_link t("edit")
      click_link t("delete")

      expect(Exhibit.count).to eq 0
      expect(Painting.count).to eq 1

      painting.reload
      expect(painting.exhibit).to eq nil
    end

    it "remove all paintings" do
      click_link t("painting.paintings")
      click_link painting.title
      click_link t("edit")
      select exhibit.name, from: t("exhibit.exhibit")
      click_button t("save")

      exhibit.reload
      painting.reload
      expect(exhibit.paintings).to eq [painting]
      expect(exhibit.paintings_count).to eq 1
      expect(painting.exhibit).to eq exhibit

      click_link exhibit.name
      click_link t("exhibit.remove")

      expect(Exhibit.count).to eq 1
      expect(Painting.count).to eq 1

      exhibit.reload
      painting.reload
      expect(exhibit.paintings).to eq []
      expect(exhibit.paintings_count).to eq 0
      expect(exhibit.previous).to eq true
      expect(painting.exhibit).to eq nil
    end
  end

  context "guests" do
    before(:each) do
      visit root_path
    end

    it "can‘t index" do
      expect(page).to_not have_css "#admin a", text: t("exhibit.exhibits")
      visit exhibits_path
      expect_forbidden page
    end

    it "can‘t view" do
      visit exhibit_path exhibit
      expect_forbidden page
    end

    it "can‘t create" do
      visit new_exhibit_path
      expect_forbidden page
    end
  end
end
