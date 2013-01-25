require 'test_helper'

class TransactionTest < ActionDispatch::IntegrationTest

  context 'a visitor viewing the transactions page' do
    
    setup do
      DatabaseCleaner.clean
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

    should 'see a list of linked envelopes' do
      assert page.has_link? @envelope.name
      assert page.has_content? @envelope.balance.format
      click_link @envelope.name
      assert_equal envelope_transactions_path(@envelope), page.current_path
    end

    should 'see a list of accounts' do
      assert page.has_link? @account.name
      assert page.has_content? @account.balance.format
      click_link @account.name
      assert_equal account_transactions_path(@account), page.current_path
    end

    should 'see a link to create a new envelope' do
      assert page.has_link? 'new envelope'
      click_link 'new envelope'
      assert_equal new_envelope_path, page.current_path
    end

    should 'see a link to create a new account' do
      assert page.has_link? 'new account'
      click_link 'new account'
      assert_equal new_account_path, page.current_path
    end

  end


end
