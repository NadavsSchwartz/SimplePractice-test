source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Configuration
gem 'dotenv-rails'
gem 'config'

# Core
gem 'pg'
gem 'puma', '~> 3.11'
gem 'rails', '~> 6.0.3'
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem 'rspec-rails', '~> 4.0.1'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'has_scope'
end

group :development do
  gem 'listen', '~> 3.2'
end
