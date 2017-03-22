Rails.application.routes.draw do
  root 'home#index', as: 'home_index'

  resources :cards do
    patch 'review', on: :member
  end
end
