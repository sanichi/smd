FactoryBot.define do
  factory :user do
    admin        { [true, false].sample }
    name         { Faker::Name.name.truncate(User::MAX_NAME) }
    password     { Faker::Internet.password(min_length: User::MIN_PASSWORD, special_characters: true) }
    otp_required { false }
    otp_secret   { otp_required ? User::OTP_TEST_SECRET : nil }
    last_otp_at  { otp_required ? 1.send(%w/week day hour/.sample).ago.to_i : nil }
  end
end
