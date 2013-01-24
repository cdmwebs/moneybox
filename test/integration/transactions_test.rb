require 'test_helper'

class TransactionTest < ActionDispatch::IntegrationTest

  fixtures :all

  context 'a visitor viewing the transactions page' do
    
    setup do
      visit transactions_path
    end

    should 'see a list of transactions' do
      first = transactions(:first).find
      assert page.has_content? first.name
      assert page.has_content? first.amount
      assert page.has_content? first.envelope.name
    end

  end


end
