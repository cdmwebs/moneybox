require 'test_helper'

class TransactionTest < ActionDispatch::IntegrationTest

  context 'a visitor viewing the transactions page' do
    
    setup do
      @envelope = FactoryGirl.create :envelope
      @account = FactoryGirl.create :account
      @transaction = FactoryGirl.create( :transaction, envelope: @envelope, account: @account)
      visit transactions_path
    end

    should 'see a list of transactions' do
      assert page.has_content? @transaction.payee
      assert page.has_content? @transaction.amount.to_s
      assert page.has_content? @transaction.envelope.name
      assert page.has_content? @transaction.account.name
    end

  end


end
