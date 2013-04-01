require 'spec_helper'
include ApplicationHelper

describe 'a visitor' do

  before :each do
    browser_sign_in
    @envelope = FactoryGirl.create :envelope
    @account = FactoryGirl.create :account
    10.times do |i|
      entry_date = (i-3).weeks.ago.to_date
      FactoryGirl.create( :transaction, amount: -10, envelope: @envelope, account: @account, entry_date: entry_date)
    end
    @statement = FactoryGirl.create :statement, start_balance: 0, end_balance: -30, account: @account, start_date: 32.days.ago, end_date: 1.day.ago
    visit statements_path
  end

  it 'can see a list of statements' do
    visit page.current_path
    page.should have_content(@statement.start_balance)
    page.should have_content(@statement.end_balance)
    page.should have_content(@statement.start_date.to_date)
    page.should have_content(@statement.end_date.to_date)
    page.should have_content(@statement.account.name)
  end

  it 'can create a new statement' do
    num_statements = Statement.all.size
    click_link 'new statement'
    page.current_path.should eq(new_statement_path)
    fill_in 'statement_start_date', with: 32.days.ago
    fill_in 'statement_end_date', with: 1.day.ago
    fill_in 'statement_start_balance', with: 0
    fill_in 'statement_end_balance', with: -30
    select @account.name, from: 'statement_account_id'
    click_button 'Create Statement'
    Statement.all.size.should eq(num_statements+1)
  end

  it 'can see possible transactions for a statement' do
    visit statement_path(@statement)
    page.should have_content(nice_date(@statement.start_date))
    page.should have_content(nice_date(@statement.end_date))
    @statement.possible_transactions.all.each do |t|
      page.should have_content(t.payee)
    end
  end

end