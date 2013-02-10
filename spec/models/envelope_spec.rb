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

end