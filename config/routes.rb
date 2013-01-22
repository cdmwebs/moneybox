Moneybox::Application.routes.draw do

  resources :envelopes, :accounts do
    member do
      resources :transactions
    end
  end

  resources :transactions, :envelopes, :accounts

  root to: 'transactions#index'

end
