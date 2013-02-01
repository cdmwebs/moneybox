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
      assert_equal edit_envelope_path(@envelope), page.current_path
    end

    should 'see a list of linked accounts' do
      assert page.has_link? @account.name
      assert page.has_content? @account.balance.format
      click_link @account.name
      assert_equal edit_account_path(@account), page.current_path
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

    should 'see a link to create a new transaction' do
      assert page.has_link? 'new transaction'
      click_link 'new transaction'
      assert_equal new_transaction_path, page.current_path
    end

    should 'be able to create a new transaction' do
      click_link 'new transaction'
      fill_in 'transaction_created_at', with: Time.now.to_date
      fill_in 'Payee', with: 'New Payee'
      fill_in 'Amount', with: 55.55
      select @envelope.name, from: 'Envelope'
      select @account.name, from: 'Account'
      click_button 'Create Transaction'
      assert_equal root_path, page.current_path
      within '.span6' do
        assert page.has_content?('transaction created')
        assert page.has_content?('New Payee')
        assert page.has_content?('55.55')
        assert page.has_content?(@envelope.name)
        assert page.has_content?(@account.name)
      end
    end

    should 'see errors for an invalid transaction' do
      click_link 'new transaction'
      fill_in 'transaction_created_at', with: Time.now.to_date
      fill_in 'Amount', with: 55.55
      click_button 'Create Transaction'
      assert page.has_css? '.error'
    end

    should 'be able to edit a transaction' do
      find("#edit-transaction-#{@transaction.id}").click
      fill_in 'Payee', with: 'Edited Payee'
      fill_in 'Amount', with: 66.66
      click_button 'Update Transaction'
      assert_equal root_path, page.current_path
      within '.span6' do
        assert page.has_content?('transaction updated')
        assert page.has_content?('Edited Payee')
        assert page.has_content?('66.66')
        assert page.has_content?(@envelope.name)
        assert page.has_content?(@account.name)
      end
    end

  end


end
