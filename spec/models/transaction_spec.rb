require 'spec_helper'

describe Transaction do

  before :each do
    @account = FactoryGirl.create( :account )
    @envelope = FactoryGirl.create( :envelope )
    @initial_account_balance = @account.balance
    @initial_envelope_balance = @envelope.balance
    @transaction = FactoryGirl.create( :transaction, amount: -10, account: @account, envelope: @envelope )
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

  describe 'updates account and envelope balances' do

    it 'after create' do
      @account.balance.should eq(@initial_account_balance + @transaction.amount)
      @envelope.balance.should eq(@initial_envelope_balance + @transaction.amount)
    end

    it 'after updating amount' do
      @transaction.update_attribute :amount, -12.00
      @account.reload
      @envelope.reload
      @account.balance.should eq(@initial_account_balance + @transaction.amount)
      @envelope.balance.should eq(@initial_envelope_balance + @transaction.amount)
    end

    it 'after updating association' do
      @account2 = FactoryGirl.create( :account )
      @envelope2 = FactoryGirl.create( :envelope )
      @transaction.update_attributes(account: @account2, envelope: @envelope2)
      @account.reload
      @envelope.reload
      @account.balance.should eq(@initial_account_balance)
      @envelope.balance.should eq(@initial_envelope_balance)
    end

    it 'after destroy' do
      @transaction.destroy
      @account.balance.should eq(@initial_account_balance)
      @envelope.balance.should eq(@initial_envelope_balance)
    end

  end

end


