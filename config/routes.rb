Moneybox::Application.routes.draw do

  devise_for :users

  resources :envelopes, :accounts do
    resources :transactions
  end

  resources :envelopes, :accounts
  resources :transactions do
    collection do
      get 'import'
      post 'import'
    end
  end


  root to: 'envelopes#index'

end
