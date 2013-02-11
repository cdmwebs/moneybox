require 'spec_helper'

describe Envelope do

  it 'includes an income flag' do
    @envelope = FactoryGirl.create :envelope
    @envelope.income.should eq(false)
  end

  it 'returns records ordered by income, negative, positive and empty balances' do
    empty_envelope = FactoryGirl.create( :envelope, balance: 0 )
    income_envelope = FactoryGirl.create( :envelope, balance: 0, income: true )
    negative_envelope = FactoryGirl.create( :envelope, balance: -10 )
    positive_envelope = FactoryGirl.create( :envelope, balance: 10 )
    envelopes = Envelope.ordered
    envelopes[0].should eq(income_envelope)
    envelopes[1].should eq(negative_envelope)
    envelopes[2].should eq(positive_envelope)
    envelopes[3].should eq(empty_envelope)
  end

  it 'can transfer between envelopes' do
    envelope1 = FactoryGirl.create :envelope, balance: 50
    envelope2 = FactoryGirl.create :envelope, balance: 100
    balance1 = envelope1.balance
    balance2 = envelope2.balance
    amount = 25.00
    Envelope.transfer(envelope2, envelope1, amount)
    envelope1.reload
    envelope2.reload
    envelope1.balance_cents.should eq((balance1 + amount) * 100)
    envelope2.balance_cents.should eq((balance2 - amount) * 100)
  end

end