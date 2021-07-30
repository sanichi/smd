require 'rails_helper'

describe Painting do
  let!(:user)     { create(:user, admin: false) }
  let!(:painting) { create(:painting, archived: false) }
  let(:data)      { build(:painting) }

  context "users" do
    before(:each) do
      login(user)
      click_link t("painting.paintings")
    end

    context "create" do
      it "success" do
        click_link t("painting.new")
        fill_in t("painting.title"), with: data.title
        fill_in t("painting.filename"), with: data.filename
        fill_in t("painting.width"), with: data.width
        fill_in t("painting.height"), with: data.height
        select t("painting.medias.#{data.media}"), from: t("painting.media")
        select t("pages.gallery#{data.gallery}.title"), from: t("painting.gallery")
        select data.stars.to_s, from: t("painting.stars")
        fill_in t("painting.price"), with: data.price
        data.sold ? check(t("painting.sold")) : uncheck(t("painting.sold"))
        data.archived ? check(t("painting.archived")) : uncheck(t("painting.archived"))
        click_button t("save")

        expect(page).to have_title data.title
        expect(Painting.count).to eq 2
        p = Painting.by_updated.first
        expect(p.title).to eq data.title
        expect(p.filename).to eq data.filename
        expect(p.width).to eq data.width
        expect(p.height).to eq data.height
        expect(p.media).to eq data.media
        expect(p.gallery).to eq data.gallery
        expect(p.price).to eq data.price
        expect(p.sold).to eq data.sold
        expect(p.archived).to eq data.archived
        expect(p.stars).to eq data.stars
        expect(p.image_width).to eq 700 # test.jpg image
        expect(p.image_height).to eq 600 # test.jpg image
      end

      it "failure" do
        click_link t("painting.new")
        fill_in t("painting.title"), with: data.title
        fill_in t("painting.width"), with: data.width
        fill_in t("painting.height"), with: data.height
        select t("painting.medias.#{data.media}"), from: t("painting.media")
        select t("pages.gallery#{data.gallery}.title"), from: t("painting.gallery")
        select data.stars.to_s, from: t("painting.stars")
        fill_in t("painting.price"), with: data.price
        data.sold ? check(t("painting.sold")) : uncheck(t("painting.sold"))
        click_button t("save")

        expect(page).to have_title t("painting.new")
        expect(Painting.count).to eq 1
        expect_error(page, "invalid")
      end
    end

    context "edit" do
      it "success" do
        click_link painting.title
        click_link t("edit")

        expect(page).to have_title t("painting.edit")

        fill_in t("painting.title"), with: data.title
        select t("painting.medias.#{data.media}"), from: t("painting.media")
        select t("pages.gallery#{data.gallery}.title"), from: t("painting.gallery")
        fill_in t("painting.price"), with: data.price
        data.sold ? check(t("painting.sold")) : uncheck(t("painting.sold"))
        data.archived ? check(t("painting.archived")) : uncheck(t("painting.archived"))
        select data.stars.to_s, from: t("painting.stars")
        click_button t("save")

        expect(page).to have_title data.title
        expect(Painting.count).to eq 1
        p = Painting.by_updated.first
        expect(p.title).to eq data.title
        expect(p.media).to eq data.media
        expect(p.gallery).to eq data.gallery
        expect(p.price).to eq data.price
        expect(p.sold).to eq data.sold
        expect(p.archived).to eq data.archived
        expect(p.stars).to eq data.stars
        expect(p.image_width).to eq 700 # test.jpg image
        expect(p.image_height).to eq 600 # test.jpg image
      end
    end
  end

  context "guests" do
    before(:each) do
      visit root_path
    end

    it "index" do
      expect(page).to_not have_css "a", text: t("painting.paintings")
      visit paintings_path
      expect_forbidden page
    end

    it "view" do
      visit painting_path(painting)
      expect_forbidden page
    end

    it "create" do
      visit new_painting_path
      expect_forbidden page
    end

    it "edit" do
      visit edit_painting_path(painting)
      expect_forbidden(page)
    end
  end
end
