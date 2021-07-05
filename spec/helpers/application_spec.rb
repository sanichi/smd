require 'rails_helper'

describe ApplicationHelper do
  let(:pic) { ApplicationHelper::PICTURES }

  it "1 or more pictures" do
    expect(pic.length).to be > 0
  end

  it "4 galleries" do
    gals = pic.map{ |p| p.g }.uniq.sort
    expect(gals.length).to eq 4
    expect(gals.first).to eq 1
    expect(gals.last).to eq 4
  end

  it "selectable or not" do
    sel = pic.map{ |p| p.s }.uniq.sort
    expect(sel.length).to eq 2
    expect(sel.first).to eq 0
    expect(sel.last).to eq 1
  end

  it "unique files" do
    files = pic.map{ |p| p.file }.uniq
    expect(files.length).to eq pic.length
  end

  it "main images exist" do
    pic.each do |p|
      expect(Rails.root + "public" + p.src).to exist
    end
  end

  it "thumbnails exist" do
    pic.each do |p|
      expect(Rails.root + "public" + p.src(true)).to exist
    end
  end

  it "pixels look good" do
    pic.each do |p|
      expect(p.px).to match(/\A[1-9]\d\dx[1-9]\d\d\z/)
    end
  end

  it "sizes look good" do
    pic.each do |p|
      expect(p.cm).to match(/\A(00x00|[1-9]\dx[1-9]\d)\z/)
    end
  end

  it "valid types" do
    expect(pic.map{ |p| p.type }.uniq.sort.join("|")).to eq "cc|mm|ol|pt|wc"
  end

  it "sold or not" do
    ava = pic.map{ |p| p.sold }.uniq.sort
    expect(ava.length).to eq 2
    expect(ava.first).to eq "a"
    expect(ava.last).to eq "s"
  end

  it "price valid or nil" do
    pic.each do |p|
      expect(p.price.nil? || p.valid_price?).to be true
    end
  end

  it "unique names" do
    names = pic.map{ |p| p.name }.uniq
    expect(names.length).to eq pic.length
  end
end
