require 'test_helper'

class EnvelopeTest < ActionDispatch::IntegrationTest

  context 'a visitor viewing the transactions page' do
    
    setup do
      @envelope = FactoryGirl.create :envelope
      @account = FactoryGirl.create :account
      @transaction = FactoryGirl.create( :transaction, envelope: @envelope, account: @account)
      visit transactions_path
    end

    should 'be able to create a new envelope' do
      num_records = Envelope.count
      click_link 'new envelope'
      fill_in 'Name', with: 'Test Envelope'
      fill_in 'Balance', with: '11.72'
      click_button 'Create Envelope'
      assert_equal num_records + 1, Envelope.count
    end

    should 'see errors attempting to create an invalid envelope' do
      num_records = Envelope.count
      click_link 'new envelope'
      fill_in 'Name', with: ''
      fill_in 'Balance', with: '11.72'
      click_button 'Create Envelope'
      assert_equal num_records, Envelope.count
      assert page.has_css? '.error'
    end

  end


end
