require 'spec_helper'

describe Account do

  it 'returns records ordered by negative, positive and empty balances' do
    empty_account = FactoryGirl.create( :account, balance: 0 )
    positive_account = FactoryGirl.create( :account, balance: 10 )
    negative_account = FactoryGirl.create( :account, balance: -10 )
    accounts = Account.ordered
    accounts[0].should eq(negative_account)
    accounts[1].should eq(positive_account)
    accounts[2].should eq(empty_account)
  end

end