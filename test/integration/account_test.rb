require 'test_helper'

class AccountTest < ActionDispatch::IntegrationTest

  context 'a visitor viewing the transactions page' do
    
    setup do
      @envelope = FactoryGirl.create :envelope
      @account = FactoryGirl.create :account
      @transaction = FactoryGirl.create( :transaction, envelope: @envelope, account: @account)
      visit transactions_path
    end

    should 'be able to create a new account' do
      num_records = Account.count
      click_link 'new account'
      fill_in 'Name', with: 'Test Account'
      fill_in 'Balance', with: '350.00'
      click_button 'Create Account'
      assert_equal num_records + 1, Account.count
    end

    should 'see errors attempting to create an invalid account' do
      num_records = Account.count
      click_link 'new account'
      fill_in 'Name', with: ''
      fill_in 'Balance', with: '11.72'
      click_button 'Create Account'
      assert_equal num_records, Account.count
      assert page.has_css? '.error'
    end

  end


end
