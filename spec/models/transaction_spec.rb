require 'spec_helper'

describe Transaction do

  before :each do
    @account = FactoryGirl.create( :account )
    @envelope = FactoryGirl.create( :envelope )
    @initial_account_balance = @account.balance
    @initial_envelope_balance = @envelope.balance
  end

  it 'requires a payee' do
    transaction = FactoryGirl.build( :transaction, payee: nil)
    transaction.should_not be_valid
  end

  it 'requires a numeric amount' do
    transaction = FactoryGirl.build( :transaction, amount: 'zero')
    transaction.should_not be_valid
  end

  it 'requires a non-zero amount' do
    transaction = FactoryGirl.build( :transaction, amount: 0)
    transaction.should_not be_valid
  end

  it 'updates account and envelope balances after create' do
    transaction = FactoryGirl.create( :transaction, amount: -10, account: @account, envelope: @envelope )
    @account.balance.should eq(@initial_account_balance + transaction.amount)
    @envelope.balance.should eq(@initial_envelope_balance + transaction.amount)
  end

  it 'updates account and envelope balances after update' do
    transaction = FactoryGirl.create( :transaction, amount: -10, account: @account, envelope: @envelope )
    transaction.update_attribute :amount, -12.00
    @account.balance.should eq(@initial_account_balance + transaction.amount)
    @envelope.balance.should eq(@initial_envelope_balance + transaction.amount)
  end

  it 'updates account and envelope balances after destroy' do
    transaction = FactoryGirl.create( :transaction, amount: -10, account: @account, envelope: @envelope )
    transaction.destroy
    @account.balance.should eq(@initial_account_balance)
    @envelope.balance.should eq(@initial_envelope_balance)
  end

end


