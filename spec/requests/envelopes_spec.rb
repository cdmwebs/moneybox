require 'spec_helper'

describe "A visitor" do

  before :each do
    browser_sign_in
    @envelope = FactoryGirl.create :envelope
    @account = FactoryGirl.create :account
    @transaction = FactoryGirl.create( :transaction, envelope: @envelope, account: @account)
    visit envelopes_path
  end

  it 'can see income envelopes before expense envelopes' do
    @income_envelope = FactoryGirl.create :envelope, income: true
    visit page.current_path
    page.all('table.envelopes tr')[1].should have_content(@income_envelope.name)
  end

  it 'can create a new envelope' do
    num_records = Envelope.count
    click_link 'new envelope'
    fill_in 'Name', with: 'Test Envelope'
    fill_in 'Balance', with: '350.00'
    click_button 'Create Envelope'
    Envelope.count.should eq(num_records + 1)
  end

  it 'can edit an envelope' do
    click_link "edit-envelope-#{@envelope.id}"
    fill_in 'Name', with: 'Updated Test Envelope'
    fill_in 'Balance', with: '10'
    click_button 'Update Envelope'
    @envelope.reload
    @envelope.name.should eq('Updated Test Envelope')
    @envelope.balance.to_s.should eq('10.00')
  end

  it 'can identify an envelope as an income envelope' do
    click_link "edit-envelope-#{@envelope.id}"
    check 'Income'
    click_button 'Update Envelope'
    @envelope.reload
    @envelope.income.should eq(true)
  end

  it 'can see errors attempting to create an invalid envelope' do
    num_records = Envelope.count
    click_link 'new envelope'
    fill_in 'Name', with: ''
    fill_in 'Balance', with: '11.72'
    click_button 'Create Envelope'
    Envelope.count.should eq(num_records)
    page.should have_css('.error')
  end

  it 'can see delete links next to each envelope' do
    page.should have_css("#delete-envelope-#{@envelope.id}")
  end

end
