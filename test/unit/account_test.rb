require 'test_helper'

class AccountTest < ActiveSupport::TestCase

  should have_many :transactions

end
