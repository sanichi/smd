FactoryBot.define do
  factory :painting do
    title    { Faker::Lorem.paragraph.truncate(Painting::TITLE) }
    filename { Faker::Lorem.words(number: 3).join("_").truncate(Painting::TITLE) }
    width    { [rand(Painting::SIZE), nil].sample }
    height   { [rand(Painting::SIZE), nil].sample }
    gallery  { rand(Painting::GALLERY) }
    media    { Painting::MEDIA.sample }
    price    { rand(Painting::PRICE) }
    sold     { [true, false].sample }
    stars    { rand(Painting::STARS) }
  end
end
