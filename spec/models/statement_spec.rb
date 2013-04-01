require 'spec_helper'

describe Statement do

  it { should have_many(:transactions) }
  it { should belong_to(:account) }

  before :each do
    @envelope = FactoryGirl.create :envelope
    @account = FactoryGirl.create :account
    10.times do |i|
      entry_date = (i-3).weeks.ago.to_date
      FactoryGirl.create( :transaction, amount: -10, envelope: @envelope, account: @account, entry_date: entry_date)
    end
    @transactions = Transaction.all
    @statement = FactoryGirl.create :statement, start_balance: 0, end_balance: -30, account: @account, start_date: 32.days.ago, end_date: 1.day.ago
  end

  it 'returns possible transactions within 3 days of start/end dates' do
    @transactions.each do |t|
      if t.entry_date >= (@statement.start_date - 3.days).to_date && t.entry_date <= (@statement.end_date + 3.days).to_date
        @statement.possible_transactions.include?(t).should be_true
      end
    end
  end

  it 'returns the difference between start and end balances' do
    @statement.balance_difference.should eq(-30.to_money)
  end

  it 'returns to total transaction amount' do
    @statement.transactions << @statement.possible_transactions.first(2)
    @statement.save
    @statement.reload
    @statement.transaction_total.should eq(-20.to_money)
  end

  it 'returns a false reconciled status when transactions and balance_differences do not match' do
    @statement.reconciled?.should be_false
  end

  it 'returns a true reconciled status when transactions and balance_differences do match' do
    @statement.transactions << @statement.possible_transactions.first(3)
    @statement.save
    @statement.reload
    @statement.reconciled?.should be_true
  end

end
