FactoryBot.define do
  factory :painting do
    title    { Faker::Lorem.paragraph.truncate(Painting::MAX_TITLE) }
    filename { Faker::Lorem.words(number: 3).join("_").truncate(Painting::MAX_TITLE) }
    width    { [rand(Painting::MIN_SIZE..Painting::MAX_SIZE), nil].sample }
    height   { [rand(Painting::MIN_SIZE..Painting::MAX_SIZE), nil].sample }
    media    { Painting::MEDIA.sample }
    sold     { [true, false].sample }
  end
end
