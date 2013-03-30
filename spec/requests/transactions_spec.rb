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
    page.should have_content(@transaction.memo)
  end

  it 'cannot see envelope transfers in standard view' do
    envelope2 = FactoryGirl.create :envelope
    Envelope.transfer(@envelope, envelope2, 20)
    visit page.current_path
    page.should have_no_content('Transfer to')
  end

  it 'can filter transaction list by clicking envelope name' do
    envelope2 = FactoryGirl.create :envelope
    Envelope.transfer(@envelope, envelope2, 20)
    click_link(@envelope.name)
    page.current_path.should eq(envelope_transactions_path(@envelope.id))
    page.should have_content('Transfer to')
  end

  it 'can filter transaction list by clicking account name' do
    click_link(@account.name)
    page.current_path.should eq(account_transactions_path(@account.id))
  end

  it 'can see a running envelope balance when filtered by envelope' do
    click_link(@envelope.name)
    find("#transaction_#{@transaction.id}").should have_content(@transaction.current_envelope_balance.format)
  end

  it 'can see a running account balance when filtered by account' do
    click_link(@account.name)
    find("#transaction_#{@transaction.id}").should have_content(@transaction.current_account_balance.format)
  end

  it 'can see a link to create a new transaction' do
    page.should have_link('new transaction')
    click_link 'new transaction'
    page.current_path.should eq(new_transaction_path)
  end

  it 'can choose withdrawal for a transaction' do
    visit new_transaction_path
    fill_in 'Payee', with: 'New withdrawal'
    fill_in 'Amount', with: 10
    fill_in 'Memo', with: 'My sample transaction'
    select @envelope.name, from: 'Envelope'
    select @account.name, from: 'Account'
    select 'withdrawal', from: 'withdrawal'
    click_button 'Create Transaction'
    transaction = Transaction.find_by_amount_cents(-1000)
    transaction.amount.to_s.should eq('-10.00')
  end

  it 'can choose deposit for a transaction' do
    visit new_transaction_path
    fill_in 'Payee', with: 'New withdrawal'
    fill_in 'Amount', with: -20
    select @envelope.name, from: 'Envelope'
    select @account.name, from: 'Account'
    select 'deposit', from: 'withdrawal'
    click_button 'Create Transaction'
    transaction = Transaction.find_by_amount_cents(2000)
    transaction.amount.to_s.should eq('20.00')
  end

  it 'can be able to create a new transaction' do
    click_link 'new transaction'
    fill_in 'Payee', with: 'New Payee'
    fill_in 'Amount', with: 55.55
    select @envelope.name, from: 'Envelope'
    select @account.name, from: 'Account'
    click_button 'Create Transaction'
    page.current_path.should eq(transactions_path)
    page.should have_content('transaction created')
    page.should have_content('New Payee')
    page.should have_content('55.55')
    page.should have_content(@envelope.name)
    page.should have_content(@account.name)
  end

  it 'can see errors for an invalid transaction' do
    click_link 'new transaction'
    fill_in 'Amount', with: 55.55
    click_button 'Create Transaction'
    page.should have_css('.error')
  end

  it 'can edit a transaction' do
    find("#edit-transaction-#{@transaction.id}").click
    fill_in 'Payee', with: 'Edited Payee'
    fill_in 'Amount', with: 66.66
    click_button 'Update Transaction'
    page.current_path.should eq(transactions_path)
    page.should have_content('transaction updated')
    page.should have_content('Edited Payee')
    page.should have_content('66.66')
    page.should have_content(@envelope.name)
    page.should have_content(@account.name)
  end

  it 'will see paged transactions with pagination links' do
    (Transaction.per_page + 3).times do
      FactoryGirl.create :transaction
    end
    visit page.current_path
    page.should have_css('tr.transaction', count: Transaction.per_page)
    page.should have_css('.pagination')
  end

  it 'can attach a PDF to a transaction' do
    click_link 'new transaction'
    fill_in 'Payee', with: 'Create Attachment Payee'
    fill_in 'Amount', with: 55.55
    select @envelope.name, from: 'Envelope'
    select @account.name, from: 'Account'
    attach_file 'transaction_attachment', "#{Rails.root}/spec/support/receipt.pdf"
    click_button 'Create Transaction'
    Transaction.find_by_payee('Create Attachment Payee').attachment_file_name.should eq('receipt.pdf')
  end

  it 'cannot attach non-PDF files to a transaction' do
    click_link 'new transaction'
    fill_in 'Payee', with: 'New Payee'
    fill_in 'Amount', with: 55.55
    select @envelope.name, from: 'Envelope'
    select @account.name, from: 'Account'
    attach_file 'transaction_attachment', "#{Rails.root}/spec/support/transactions.csv"
    click_button 'Create Transaction'
    page.should have_content('Please see errors')
  end

  it 'can delete a transaction' do
    click_link "delete-transaction-#{@transaction.id}"
    Transaction.all.count.should eq(0)
  end

  it 'can see an attachment link if attachment present' do
    click_link 'new transaction'
    fill_in 'Payee', with: 'Attachment Payee'
    fill_in 'Amount', with: 55.55
    select @envelope.name, from: 'Envelope'
    select @account.name, from: 'Account'
    attach_file 'transaction_attachment', "#{Rails.root}/spec/support/receipt.pdf"
    click_button 'Create Transaction'
    last = Transaction.find_by_payee('Attachment Payee')
    visit edit_transaction_path(last.id)
    page.should have_link('view attachment')
  end

  it 'can toggle a transaction status' do
    @transaction.should be_open
    within("#transaction_#{@transaction.id}") do
      click_link("toggle-status-transaction-#{@transaction.id}")
    end
    @transaction.reload
    @transaction.should be_cleared
  end

end

describe 'an admin' do

  describe 'importing transactions' do

    before :each do
      @transaction = FactoryGirl.create( :transaction)
      browser_sign_in
      visit import_transactions_path
    end

    it 'should be able to append new transactions' do
      attach_file 'transaction_attachment', "#{Rails.root}/spec/support/transactions.csv"
      click_button 'Upload'
      Transaction.count.should eq(6)
      Transaction.deposits.count.should eq(1)
      Transaction.withdrawals.count.should eq(5)
      Envelope.count.should eq(3)
      Account.count.should eq(3)
      Envelope.empty.count.should eq(0)
      Account.empty.count.should eq(0)
      Envelope.positive.count.should eq(1)
      Account.positive.count.should eq(2)
      Envelope.negative.count.should eq(2)
      Account.negative.count.should eq(1)
      Transaction.first.memo.should_not be_blank
    end

    it 'should be able to replace existing transactions' do
      attach_file 'transaction_attachment', "#{Rails.root}/spec/support/transactions.csv"
      check 'replace'
      click_button 'Upload'
      Transaction.count.should eq(5)
      Envelope.count.should eq(2)
      Account.count.should eq(2)
      Envelope.empty.count.should eq(0)
      Account.empty.count.should eq(0)
    end

    it 'should be able to zero account balances' do
      attach_file 'transaction_attachment', "#{Rails.root}/spec/support/transactions.csv"
      check 'reset-accounts'
      click_button 'Upload'
      Account.empty.count.should eq(Account.count)
      Envelope.empty.count.should_not eq(Envelope.count)
    end

    it 'should be able to zero envelope balances' do
      attach_file 'transaction_attachment', "#{Rails.root}/spec/support/transactions.csv"
      check 'reset-envelopes'
      click_button 'Upload'
      Account.empty.count.should_not eq(Account.count)
      Envelope.empty.count.should eq(Envelope.count)
    end

    it 'should see errors for invalid transactions' do
      attach_file 'transaction_attachment', "#{Rails.root}/spec/support/bad_transactions.csv"
      check 'reset-accounts'
      click_button 'Upload'
      page.should have_content("can't be blank")
      page.should have_content('is reserved')
      page.should have_content('There were errors')
    end


  end

  it 'should be able to export transactions' do
    @transactions = FactoryGirl.create_list( :transaction, 5 )
    visit export_transactions_path
  end

end
