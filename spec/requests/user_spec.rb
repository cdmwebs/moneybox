require 'spec_helper'

describe 'A visitor' do

  it 'cannot access any page without logging in' do
    visit transactions_path
    page.current_path.should eq(new_user_session_path)
    visit accounts_path
    page.current_path.should eq(new_user_session_path)
    visit envelopes_path
    page.current_path.should eq(new_user_session_path)
    visit new_transaction_path
    page.current_path.should eq(new_user_session_path)
  end
  
  it 'can sign in with valid credentials' do
    user = FactoryGirl.build :user
    password = user.password
    user.save
    visit root_path
    page.current_path.should eq(new_user_session_path)
    fill_in 'Email', with: user.email
    fill_in "Password", with: user.password
    click_button 'Sign in'
    page.current_path.should eq(root_path)
  end

  it 'cannot sign in with invalid credentials' do
    visit root_path
    fill_in 'Email', with: 'flopsy@mailinator.com'
    fill_in "Password", with: 'badpassword'
    click_button 'Sign in'
    page.current_path.should eq(new_user_session_path)
  end


end
