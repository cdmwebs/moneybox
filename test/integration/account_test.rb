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

    should 'be able to edit an account' do
      click_link @account.name
      fill_in 'Name', with: 'Updated Test Account'
      fill_in 'Balance', with: '10'
      click_button 'Update Account'
      @account.reload
      assert_equal 'Updated Test Account', @account.name
      assert_equal '10.00', @account.balance.to_s
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

    should 'see delete links next to each account' do
      within "#account-#{@account.id}" do
        assert page.has_css? 'a.delete-link'
      end
    end

  end


end
