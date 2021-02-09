require 'rails_helper'

describe PagesController do
  before(:each) do
    visit index_path
  end

  it "index" do
    expect(page).to have_title t("pages.index.title")
  end

  it "gallery 1" do
    within ".dropdown" do
      click_link t("pages.gallery1.title")
    end

    expect(page).to have_title t("pages.gallery1.title")
  end

  it "gallery 2" do
    within ".dropdown" do
      click_link t("pages.gallery2.title")
    end

    expect(page).to have_title t("pages.gallery2.title")
  end

  it "gallery 3" do
    within ".dropdown" do
      click_link t("pages.gallery3.title")
    end

    expect(page).to have_title t("pages.gallery3.title")
  end

  it "gallery 4" do
    within ".dropdown" do
      click_link t("pages.gallery4.title")
    end

    expect(page).to have_title t("pages.gallery4.title")
  end

  it "exhibitions" do
    click_link t("pages.exhibitions.title")

    expect(page).to have_title t("pages.exhibitions.title")
  end
end
