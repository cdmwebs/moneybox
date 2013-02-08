require 'spec_helper'

describe 'a visitor viewing the transactions page' do
  
  before :each do
    browser_sign_in
    @envelope = FactoryGirl.create :envelope
    @account = FactoryGirl.create :account
    @transaction = FactoryGirl.create( :transaction, envelope: @envelope, account: @account)
    visit transactions_path
  end

  it 'can see a list of transactions' do
    page.should have_content(@transaction.payee)
    page.should have_content(@transaction.amount.to_s)
    page.should have_content(@transaction.envelope.name)
    page.should have_content(@transaction.account.name)
  end

  it 'can see a list of linked envelopes' do
    page.should have_link(@envelope.name)
    page.should have_content(@envelope.balance.format)
    click_link @envelope.name
    page.current_path.should eq(edit_envelope_path(@envelope))
  end

  it 'can see a list of linked accounts' do
    page.should have_link(@account.name)
    page.should have_content(@account.balance.format)
    click_link @account.name
    page.current_path.should eq(edit_account_path(@account))
  end

  it 'can see a link to create a new envelope' do
    page.should have_link('new envelope')
    click_link 'new envelope'
    page.current_path.should eq(new_envelope_path)
  end

  it 'can see a link to create a new account' do
    page.should have_link('new account')
    click_link 'new account'
    page.current_path.should eq(new_account_path)
  end

  it 'can see a link to create a new transaction' do
    page.should have_link('new transaction')
    click_link 'new transaction'
    page.current_path.should eq(new_transaction_path)
  end

  it 'can be able to create a new transaction' do
    click_link 'new transaction'
    fill_in 'Payee', with: 'New Payee'
    fill_in 'Amount', with: 55.55
    select @envelope.name, from: 'Envelope'
    select @account.name, from: 'Account'
    click_button 'Create Transaction'
    page.current_path.should eq(root_path)
    within '.span6' do
      page.should have_content('transaction created')
      page.should have_content('New Payee')
      page.should have_content('55.55')
      page.should have_content(@envelope.name)
      page.should have_content(@account.name)
    end
  end

  it 'can see errors for an invalid transaction' do
    click_link 'new transaction'
    fill_in 'Amount', with: 55.55
    click_button 'Create Transaction'
    page.should have_css('.error')
  end

  it 'can be able to edit a transaction' do
    find("#edit-transaction-#{@transaction.id}").click
    fill_in 'Payee', with: 'Edited Payee'
    fill_in 'Amount', with: 66.66
    click_button 'Update Transaction'
    page.current_path.should eq(root_path)
    within '.span6' do
      page.should have_content('transaction updated')
      page.should have_content('Edited Payee')
      page.should have_content('66.66')
      page.should have_content(@envelope.name)
      page.should have_content(@account.name)
    end
  end

end
