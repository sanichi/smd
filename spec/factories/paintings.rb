FactoryBot.define do
  factory :painting do
    title    { Faker::Lorem.paragraph.truncate(Painting::MAX_TITLE) }
    filename { Faker::Lorem.words(number: 3).join("_").truncate(Painting::MAX_TITLE) }
  end
end
