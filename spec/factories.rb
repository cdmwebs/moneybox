FactoryGirl.define do

  factory :envelope do
    sequence(:name) { |n| "envelope #{n}" }
    balance 100
  end

  factory :account do
    sequence(:name) { |n| "account #{n}" }
    balance 100
  end

  factory :transaction do
    sequence(:payee) { |n| "payee #{n}" }
    amount -10
    envelope
    account
  end

end