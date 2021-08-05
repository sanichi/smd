FactoryBot.define do
  factory :painting do
    title    { Faker::Lorem.paragraph.truncate(Painting::TITLE) }
    width    { [rand(Painting::SIZE), nil].sample }
    height   { [rand(Painting::SIZE), nil].sample }
    gallery  { rand(Painting::GALLERY) }
    media    { Painting::MEDIA.sample }
    price    { [rand(Painting::PRICE), nil].sample }
    print    { [rand(Painting::PRINT), nil].sample }
    sold     { [true, false].sample }
    archived { [true, false].sample }
    stars    { rand(Painting::STARS) }
    image    { test_image(%w/jpg png gif/.sample, upload: true) }
  end
end
