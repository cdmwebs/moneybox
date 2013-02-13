source 'https://rubygems.org'

ruby '1.9.3'

#-------------- Framework

gem 'rails', '3.2.11'
gem 'json'
gem 'jquery-rails'
gem 'money-rails'
gem 'simple_form'
gem 'bootstrap-datepicker-rails'
gem 'devise', '2.2.2'
gem 'bootstrap-will_paginate'
gem 'heroku'
gem 'paperclip', '~> 3.0'
gem 'aws-sdk'

group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier',         '>= 1.0.3'
  gem 'compass-rails',    '~> 1.0.3'
  gem 'bootstrap-sass', '~> 2.2.2.0'
  gem 'font-awesome-rails'
end


gem "rspec-rails", :group => [:test, :development]
gem 'sqlite3', :group => [:test, :development]

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'launchy'
  gem "guard-rspec"
  gem 'rb-fsevent', :require => false
  gem 'database_cleaner'
end

group :production do
  gem 'thin'
  gem 'pg'
end