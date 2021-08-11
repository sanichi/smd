FactoryBot.define do
  factory :exhibit do
    name     { Faker::Name.name.truncate(Exhibit::MAX_NAME) }
    link     { [Faker::Internet.url, nil].sample }
    location { Faker::Address.city.truncate(Exhibit::MAX_LOCATION) }
    previous { [true, false].sample }
  end
end
