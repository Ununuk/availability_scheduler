source 'https://rubygems.org'

# Specify your gem's dependencies in availability_scheduler.gemspec
gemspec

gem 'rake', '~> 13.0'

group :test do
  gem 'activerecord', '~> 7.2.1'
  gem 'database_cleaner-active_record'
  gem 'factory_bot'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rspec', '~> 3.0'
  gem 'shoulda-matchers', '~> 5.0'
  gem 'sqlite3', '~> 2.0.4'
end

group :development do
  gem 'rubocop', '~> 1.66.1', require: false
  gem 'rubocop-factory_bot', '~> 2.26', '>= 2.26.1', require: false
  gem 'rubocop-rake', '~> 0.6.0', require: false
  gem 'rubocop-rspec', '~> 3.0', '>= 3.0.4', require: false
end
