require 'rails_helper'

# TODO - this doesn't work with js, can't find Galleries button/link
describe PagesController do
  before(:each) do
    visit index_path
  end

  it "index" do
    expect(page).to have_title t("pages.index.title")
  end

  it "gallery 1" do
    within "#gallery-dropdown" do
      click_link t("pages.gallery1.title")
    end

    expect(page).to have_title t("pages.gallery1.title")
  end

  it "gallery 2" do
    within "#gallery-dropdown" do
      click_link t("pages.gallery2.title")
    end

    expect(page).to have_title t("pages.gallery2.title")
  end

  it "gallery 3" do
    within "#gallery-dropdown" do
      click_link t("pages.gallery3.title")
    end

    expect(page).to have_title t("pages.gallery3.title")
  end

  it "gallery 4" do
    within "#gallery-dropdown" do
      click_link t("pages.gallery4.title")
    end

    expect(page).to have_title t("pages.gallery4.title")
  end

  it "available" do
    click_link t("pages.available.title")

    expect(page).to have_title t("pages.available.title")
  end

  it "sale" do
    click_link t("pages.sale.title")

    expect(page).to have_title t("pages.sale.title")
  end

  it "exhibitions" do
    click_link t("pages.exhibitions.title")

    expect(page).to have_title t("pages.exhibitions.title")
  end
end
