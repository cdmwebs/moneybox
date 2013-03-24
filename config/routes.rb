Moneybox::Application.routes.draw do

  devise_for :users

  resources :accounts do
    resources :transactions
    collection do
      get 'transfer'
      post 'transfer'
    end
  end

  resources :envelopes do
    resources :transactions
    collection do
      get 'transfer'
      post 'transfer'
      get 'fill'
      post 'fill'
    end
  end

  resources :transactions do
    collection do
      get 'import'
      post 'import'
    end
    member do
      put 'toggle_status'
    end
  end

  resources :statements do
    resources :transactions
  end


  root to: 'envelopes#index'

end
