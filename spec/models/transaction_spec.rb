require 'spec_helper'

describe Transaction do

  let(:account) { Factory(:account) }
  let(:envelope) { Factory(:envelope) }
  let(:transaction) { Factory(:transaction) }

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
    initial_account_balance = account.balance
    initial_envelope_balance = envelope.balance
    transaction = FactoryGirl.build payee: 'Grocery Store', amount: -36.50
    account.balance.should eq(initial_account_balance + transaction.amount)
    envelope.balance.should eq(initial_envelope_balance + transaction.amount)
  end

  # should 'update account and envelope balances after update' do
  #   transaction = Transaction.create payee: 'Grocery Store', amount: -36.50, account: @account, envelope: @envelope
  #   transaction.update_attribute :amount, -12.00
  #   @account.reload
  #   @envelope.reload
  #   assert_equal @initial_account_balance + transaction.amount, @account.balance, 'account not updated'
  #   assert_equal @initial_envelope_balance + transaction.amount, @envelope.balance, 'envelope not updated'
  # end

  # should 'update account and envelope balances after destroy' do
  #   transaction = Transaction.create payee: 'Grocery Store', amount: -36.50, account: @account, envelope: @envelope
  #   transaction.destroy
  #   @account.reload
  #   @envelope.reload
  #   assert_equal @initial_account_balance, @account.balance, 'account not updated'
  #   assert_equal @initial_envelope_balance, @envelope.balance, 'envelope not updated'
  #end
end
