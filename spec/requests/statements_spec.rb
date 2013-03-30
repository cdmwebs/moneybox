require 'spec_helper'

describe 'a visitor' do

  before :each do
    browser_sign_in
    @envelope = FactoryGirl.create :envelope
    @account = FactoryGirl.create :account
    @transactions = FactoryGirl.create_list( :transaction, 3, amount: -10, envelope: @envelope, account: @account)
    visit statements_path
  end

  it 'can see a list of statements' do
    statement = FactoryGirl.create :statement, start_balance: 0, end_balance: -30, account: @account
    visit page.current_path
    page.should have_content(statement.start_balance)
    page.should have_content(statement.end_balance)
    page.should have_content(statement.start_date.to_date)
    page.should have_content(statement.end_date.to_date)
    page.should have_content(statement.account.name)
  end

  it 'can create a new statement' do
    click_link 'new statement'
    page.current_path.should eq(new_statement_path)
    fill_in 'statement_start_date', with: 32.days.ago
    fill_in 'statement_end_date', with: 1.day.ago
    fill_in 'statement_start_balance', with: 0
    fill_in 'statement_end_balance', with: -30
    select @account.name, from: 'statement_account_id'
    click_button 'Create Statement'
    page.current_path.should eq(statements_path)
    page.should have_content(32.days.ago.to_date)
  end

end