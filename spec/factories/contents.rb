FactoryBot.define do
  factory :content do
    name     { Faker::Name.name.truncate(Content::NAME) }
    markdown { Faker::Lorem.paragraphs(number: 3).join("\n\n") }
  end
end
