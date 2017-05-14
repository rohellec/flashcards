Rails.application.routes.draw do
  get 'oauths/ouath'

  get 'oauths/callback'

  root 'home#index', as: 'home_index'

  resources :cards do
    patch 'review', on: :member
  end

  resources :users, only: [:new, :create, :edit, :update]

  get  'signup', to: 'users#new'
  post 'signup', to: 'users#create'

  get    'login',  to: 'sessions#new'
  post   'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  post 'oauth/callback',  to: 'oauths#callback'
  get  'oauth/callback',  to: 'oauths#callback'
  get  'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
end
