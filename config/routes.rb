Moneybox::Application.routes.draw do

  devise_for :users

  resources :envelopes, :accounts do
    resources :transactions
  end

  resources :transactions, :envelopes, :accounts

  root to: 'transactions#new'

end
