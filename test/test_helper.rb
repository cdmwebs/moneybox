ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/poltergeist'

DatabaseCleaner.strategy = :truncation

class ActiveSupport::TestCase

end

class ActionDispatch::IntegrationTest

  include Capybara::DSL

  setup do

  end

  teardown do
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
  end

end

