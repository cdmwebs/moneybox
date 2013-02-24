require 'spec_helper'

describe Account do

  it { should have_many(:transactions) }
  it { should have_many(:statements) }

  it 'returns records ordered by negative, positive and empty balances' do
    empty_account = FactoryGirl.create( :account, balance: 0 )
    positive_account = FactoryGirl.create( :account, balance: 10 )
    negative_account = FactoryGirl.create( :account, balance: -10 )
    accounts = Account.ordered
    accounts[0].should eq(negative_account)
    accounts[1].should eq(positive_account)
    accounts[2].should eq(empty_account)
  end


  it 'can transfer between accounts' do
    account1 = FactoryGirl.create :account, balance: 50
    account2 = FactoryGirl.create :account, balance: 100
    balance_cents1 = account1.balance_cents
    balance_cents2 = account2.balance_cents
    amount = 25.00
    Account.transfer(account2, account1, amount)
    account1.reload
    account2.reload
    account1.balance_cents.should eq(balance_cents1 + amount * 100)
    account2.balance_cents.should eq(balance_cents2 - amount * 100)
    transaction = Transaction.where(account_id: account1).last
    transaction.amount.should eq('25.00')
    transaction.payee.should eq("Transfer from #{account2.name}")
    transaction = Transaction.where(account_id: account2).last
    transaction.amount.should eq('-25.00')
    transaction.payee.should eq("Transfer to #{account1.name}")
  end

end