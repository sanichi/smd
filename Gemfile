source 'https://rubygems.org'

gem 'rails', '8.0.2'
gem 'haml-rails', '~> 2.0'
gem 'sassc-rails', '~> 2.1'
gem 'bootstrap', '~> 5.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'bcrypt', '~> 3.1.7'
gem 'cancancan', '~> 3.0'
gem 'redcarpet', '~> 3.5'
gem 'meta-tags', '~> 2.12'
gem 'rotp', '~> 6.2'
gem 'rqrcode', '~> 3.1'
gem 'csv', '< 4'
gem 'sprockets-rails', '~> 3.4'
gem "importmap-rails", "~> 2.1"
gem "turbo-rails", "~> 2.0"
gem "stimulus-rails", "~> 1.3"

group :development, :test do
  gem 'rspec-rails', '< 9'
  gem 'capybara', '~> 3.28'
  gem 'byebug', platforms: :mri
  gem 'launchy', '< 4'
  gem 'factory_bot_rails', '~> 6.0'
  gem 'faker', '< 4'
  gem "selenium-webdriver", "~> 4.27"
end

group :test do
  gem 'database_cleaner-active_record', '~> 2.0'
end

group :development do
  gem 'puma', '< 7'
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-passenger', '~> 0.2', require: false
  gem 'listen', '~> 3.2'
  gem 'awesome_print', '~> 1.9', require: false
end
