Rails.application.routes.draw do
  get 'oauths/ouath'

  get 'oauths/callback'

  root 'home#index', as: 'home_index'

  resources :decks do
    patch 'switch', on: :member
    resources :cards, only: [:new, :create]
  end

  resources :cards, only: [:index, :show, :edit, :update, :destroy] do
    patch 'review', on: :member
  end
  get 'card/back', to: 'cards#back'

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
