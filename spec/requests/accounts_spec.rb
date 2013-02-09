require 'spec_helper'

describe "A visitor" do

  before :each do
    browser_sign_in
    @envelope = FactoryGirl.create :envelope
    @account = FactoryGirl.create :account
    @transaction = FactoryGirl.create( :transaction, envelope: @envelope, account: @account)
    visit accounts_path
  end

  it 'can create a new account' do
    num_records = Account.count
    click_link 'new account'
    fill_in 'Name', with: 'Test Account'
    fill_in 'Balance', with: '350.00'
    click_button 'Create Account'
    Account.count.should eq(num_records + 1)
  end

  it 'can edit an account' do
    click_link "edit-account-#{@account.id}"
    fill_in 'Name', with: 'Updated Test Account'
    fill_in 'Balance', with: '10'
    click_button 'Update Account'
    @account.reload
    @account.name.should eq('Updated Test Account')
    @account.balance.to_s.should eq('10.00')
  end

  it 'can see errors attempting to create an invalid account' do
    num_records = Account.count
    click_link 'new account'
    fill_in 'Name', with: ''
    fill_in 'Balance', with: '11.72'
    click_button 'Create Account'
    Account.count.should eq(num_records)
    page.should have_css('.error')
  end

  it 'can see delete links next to each account' do
    page.should have_css("#delete-account-#{@account.id}")
  end

end
