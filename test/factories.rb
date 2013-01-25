FactoryGirl.define do

  factory :envelope do
    name 'mortgage'
    balance 35000
  end

  factory :account do
    name 'checking'
    balance 50000
  end

  factory :transaction do
    payee 'Payee'
    amount -3572
  end

end