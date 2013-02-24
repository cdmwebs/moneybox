require 'spec_helper'

describe Statement do

  it { should have_many(:transactions) }
  it { should belong_to(:account) }

end
