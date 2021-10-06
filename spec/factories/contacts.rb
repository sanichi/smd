FactoryBot.define do
  factory :contact do
    email      { Faker::Internet.email.truncate(Contact::MAX_EMAIL) }
    first_name { Faker::Name.first_name.truncate(Contact::MAX_NAME) }
    last_name  { Faker::Name.last_name.truncate(Contact::MAX_NAME) }
  end
end
