# AGENTS.md - Sandra Mary Dickie Website

## Build/Test Commands
- Run all specs: `bundle exec rspec` or `bin/rails spec`
- Run single spec file: `bundle exec rspec spec/features/painting_spec.rb`
- Run single test: `bundle exec rspec spec/features/painting_spec.rb:25`
- Run by tag: `bundle exec rspec --tag js` 
- Run dev server: `bin/dev` or `bin/rails server`
- Database setup: `bin/rails db:create db:migrate`
- Console: `bin/rails c`

## Code Style
- Ruby/Rails app using HAML views, PostgreSQL, Bootstrap 5, Stimulus/Turbo
- Models: Use concerns (Constrainable, Pageable), strong validations, scopes, search methods
- Controllers: Use CanCanCan authorization with `load_and_authorize_resource`
- Views: HAML templates with I18n helpers `t()`, semantic HTML with Bootstrap classes
- Constants: ALL_CAPS module constants for validation ranges/arrays
- Validation: Comprehensive with custom error messages, use inclusion/length validators
- Error handling: Cleanup temp resources in ensure blocks, log errors appropriately
- Naming: snake_case for variables/methods, descriptive method names like `check_image`
- File organization: Standard Rails structure, concerns in models/concerns/
- Testing: RSpec with feature specs using Capybara, factory_bot for test data