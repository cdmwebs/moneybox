Moneybox::Application.routes.draw do

  resources :transactions, :envelopes, :accounts

  root to: 'transactions#index'

end
