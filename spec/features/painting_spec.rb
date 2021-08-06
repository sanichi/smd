require 'rails_helper'

describe Painting do
  let!(:admin)    { create(:user, admin: true) }
  let!(:user)     { create(:user, admin: false) }
  let!(:painting) { create(:painting, archived: false) }

  def enter(data)
    fill_in t("painting.title"), with: data.title
    fill_in t("painting.width"), with: data.width
    fill_in t("painting.height"), with: data.height
    select t("painting.medias.#{data.media}"), from: t("painting.media")
    select t("pages.gallery#{data.gallery}.title"), from: t("painting.gallery")
    select data.stars.to_s, from: t("painting.stars")
    fill_in t("painting.price"), with: data.price
    fill_in t("painting.print"), with: data.print
    data.sold ? check(t("painting.sold")) : uncheck(t("painting.sold"))
    data.archived ? check(t("painting.archived")) : uncheck(t("painting.archived"))
  end

  def presume(page, data, count: 2)
    expect(page).to have_title data.title
    expect(Painting.count).to eq count
    p = Painting.by_updated.first
    expect(p.title).to eq data.title
    expect(p.width).to eq data.width
    expect(p.height).to eq data.height
    expect(p.media).to eq data.media
    expect(p.gallery).to eq data.gallery
    expect(p.price).to eq data.price
    expect(p.print).to eq data.print
    expect(p.sold).to eq data.sold
    expect(p.archived).to eq data.archived
    expect(p.stars).to eq data.stars
    expect(p.version).to eq 1
    p
  end

  context "admin" do
    before(:each) do
      login(admin)
      click_link t("painting.paintings")
    end

    it "delete" do
      click_link painting.title
      click_link t("edit")
      expect(page).to have_css "a", text: t("delete")
      click_link t("delete")

      expect(page).to have_title t("painting.paintings")
      expect(Painting.count).to eq 0
    end
  end

  context "user" do
    before(:each) do
      Dir.glob("public/test/*").each { |f| FileUtils.rm(f) }
      login(user)
      click_link t("painting.paintings")
    end

    it "archive" do
      click_link t("painting.archive")
      expect(page).to have_title t("painting.archive")
    end

    it "create with JPG image" do
      click_link t("painting.new")
      data = build(:painting, image: nil)
      enter(data)
      attach_file(t("painting.image"), test_image("jpg"))
      click_button t("save")

      p = presume(page, data)
      w, h = test_image_dimensions("jpg")
      expect(p.image_width).to eq w
      expect(p.image_height).to eq h
      expect(%x|identify #{p.image_path(web: false, full: true)}|).to match("JPEG #{w}x#{h}")
      expect(%x|identify #{p.image_path(web: false, full: false)}|).to match("JPEG 100x100")
    end

    it "create with PNG image" do
      click_link t("painting.new")
      data = build(:painting, image: nil)
      enter(data)
      attach_file(t("painting.image"), test_image("png"))
      click_button t("save")

      p = presume(page, data)
      w, h = test_image_dimensions("png")
      expect(p.image_width).to eq w
      expect(p.image_height).to eq h
      expect(%x|identify #{p.image_path(web: false, full: true)}|).to match("JPEG #{w}x#{h}")
      expect(%x|identify #{p.image_path(web: false, full: false)}|).to match("JPEG 100x100")
    end

    it "create with GIF image" do
      click_link t("painting.new")
      data = build(:painting, image: nil)
      enter(data)
      attach_file(t("painting.image"), test_image("gif"))
      click_button t("save")

      p = presume(page, data)
      w, h = test_image_dimensions("gif")
      expect(p.image_width).to eq w
      expect(p.image_height).to eq h
      expect(%x|identify #{p.image_path(web: false, full: true)}|).to match("JPEG #{w}x#{h}")
      expect(%x|identify #{p.image_path(web: false, full: false)}|).to match("JPEG 100x100")
    end

    it "edit (except image)" do
      w = painting.image_width
      h = painting.image_height

      click_link painting.title
      click_link t("edit")
      expect(page).to have_title t("painting.edit")

      data = build(:painting, image: nil)
      enter(data)
      click_button t("save")

      p = presume(page, data, count: 1)
      expect(p.image_width).to eq w
      expect(p.image_height).to eq h
    end

    it "edit (only image)" do
      click_link painting.title
      click_link t("edit")
      expect(page).to have_title t("painting.edit")

      attach_file(t("painting.image"), test_image("square"))
      click_button t("save")

      expect(page).to have_title painting.title
      expect(Painting.count).to eq 1
      p = Painting.by_updated.first
      expect(p.version).to eq 2

      w, h = test_image_dimensions("square")
      expect(p.image_width).to eq w
      expect(p.image_height).to eq h
      expect(%x|identify #{p.image_path(web: false, full: true)}|).to match("JPEG #{w}x#{h}")
      expect(%x|identify #{p.image_path(web: false, full: false)}|).to match("JPEG 100x100")
    end

    it "can‘t create without image" do
      click_link t("painting.new")
      data = build(:painting, image: nil)
      enter(data)
      click_button t("save")

      expect(page).to have_title t("painting.new")
      expect(Painting.count).to eq 1
      expect_error(page, t("painting.errors.blank"))
    end

    it "can‘t create with HEIC image" do
      click_link t("painting.new")
      data = build(:painting, image: nil)
      enter(data)
      attach_file(t("painting.image"), test_image("heic"))
      click_button t("save")

      expect(page).to have_title t("painting.new")
      expect(Painting.count).to eq 1
      expect_error(page, t("painting.errors.heic"))
    end

    it "can‘t create with TIFF image" do
      click_link t("painting.new")
      data = build(:painting, image: nil)
      enter(data)
      attach_file(t("painting.image"), test_image("tiff"))
      click_button t("save")

      expect(page).to have_title t("painting.new")
      expect(Painting.count).to eq 1
      expect_error(page, t("painting.errors.format"))
    end

    it "can‘t create with small image" do
      click_link t("painting.new")
      data = build(:painting, image: nil)
      enter(data)
      attach_file(t("painting.image"), test_image("small"))
      click_button t("save")

      expect(page).to have_title t("painting.new")
      expect(Painting.count).to eq 1
      expect_error(page, t("painting.errors.small"))
    end

    it "can‘t delete" do
      click_link painting.title
      click_link t("edit")
      expect(page).to_not have_css "a", text: t("delete")
    end
  end

  context "guest" do
    before(:each) do
      visit root_path
    end

    it "can‘t index" do
      expect(page).to_not have_css "a", text: t("painting.paintings")
      visit paintings_path
      expect_forbidden page
    end

    it "can‘t archive" do
      expect(page).to_not have_css "a", text: t("painting.archive")
      visit archive_paintings_path
      expect_forbidden page
    end

    it "can‘t view" do
      visit painting_path(painting)
      expect_forbidden page
    end

    it "can‘t create" do
      visit new_painting_path
      expect_forbidden page
    end

    it "can‘t edit" do
      visit edit_painting_path(painting)
      expect_forbidden(page)
    end
  end
end
