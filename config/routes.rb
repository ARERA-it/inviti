Rails.application.routes.draw do
  resources :contributions, only: [:create, :destroy]

  get 'settings/update', to: 'settings#update'

  get 'welcome', as: 'welcome', to: 'pages#welcome'
  get 'dashboard', as: 'dashboard', to: 'pages#dashboard'

  resources :invitations
  devise_for :users
  resources :users

  get 'comments/create'
  resources :comments
  resources :opinions

  # get 'users', to: 'users#index'

  root 'pages#welcome'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
