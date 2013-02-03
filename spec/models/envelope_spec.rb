require 'spec_helper'

describe Envelope do

  before :each do
    @envelope = FactoryGirl.create :envelope
  end

  it 'includes an income flag' do
    @envelope.income.should eq(false)
  end

end