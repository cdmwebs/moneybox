Moneybox::Application.routes.draw do

  devise_for :users

  resources :envelopes, :accounts do
    resources :transactions
    collection do
      get 'transfer'
      post 'transfer'
      get 'distribute'
      post 'distribute'
    end
  end

  resources :transactions do
    collection do
      get 'import'
      post 'import'
    end
  end


  root to: 'envelopes#index'

end
