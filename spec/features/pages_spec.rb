require 'rails_helper'

describe PagesController do
  before(:each) do
    visit index_path
  end

  it "index" do
    expect(page).to have_title t("pages.index.title")
  end

  it "note" do
    click_link t("pages.note.title")

    expect(page).to have_title t("pages.note.title")
  end
end
