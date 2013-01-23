Moneybox::Application.routes.draw do

  resources :envelopes, :accounts do
    resources :transactions
  end

  resources :transactions, :envelopes, :accounts

  root to: 'transactions#index'

end
