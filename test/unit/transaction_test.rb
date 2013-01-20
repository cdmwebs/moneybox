require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

  should belong_to :account
  should belong_to :envelope

  setup do
    @account = Account.create name: 'checking', balance: 1000
    @envelope = Envelope.create name: 'groceries', balance: 300
    @initial_account_balance = @account.balance
    @initial_envelope_balance = @envelope.balance
  end

  should 'update account and envelope balances after save' do
    transaction = Transaction.create payee: 'Grocery Store', amount: -36.50, account: @account, envelope: @envelope
    @account.reload
    @envelope.reload
    assert_equal @initial_account_balance + transaction.amount, @account.balance, 'account not updated'
    assert_equal @initial_envelope_balance + transaction.amount, @envelope.balance, 'envelope not updated'
  end

  should 'update account and envelope balances after destroy' do
    transaction = Transaction.create payee: 'Grocery Store', amount: -36.50, account: @account, envelope: @envelope
    transaction.destroy
    @account.reload
    @envelope.reload
    assert_equal @initial_account_balance, @account.balance, 'account not updated'
    assert_equal @initial_envelope_balance, @envelope.balance, 'envelope not updated'
  end

end
