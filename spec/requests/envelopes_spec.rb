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

  it 'can transfer money between envelopes' do
    envelope_from = FactoryGirl.create :envelope, balance: 100
    from_balance_cents = envelope_from.balance_cents
    envelope_to = FactoryGirl.create :envelope, balance: 100
    to_balance_cents = envelope_to.balance_cents
    visit transfer_envelopes_path
    fill_in 'amount', with: 10
    select envelope_from.name, from: 'from'
    select envelope_to.name, from: 'to'
    click_button 'Transfer'
    envelope_from.reload
    envelope_to.reload
    envelope_from.balance.to_s.should eq('90.00')
    envelope_to.balance.to_s.should eq('110.00')
  end

end
