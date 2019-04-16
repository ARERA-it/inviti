Rails.application.routes.draw do
  get 'projects/edit'
  get 'projects/update'
  resources :projects, only: [:edit, :update]
  resources :accepts
  resources :contributions, only: [:create, :destroy]

  patch 'appointee', to: 'invitations#update_appointee'
  get 'settings/update', to: 'settings#update'

  get 'welcome', as: 'welcome', to: 'pages#welcome'
  get 'dashboard', as: 'dashboard', to: 'pages#dashboard'

  resources :invitations do
    get :update_invitation_expired_statuses, on: :collection
    get :autocomplete_user_display_name, on: :collection
    get :download_ics, on: :member
  end
  devise_for :users
  resources :users

  get 'comments/create'
  resources :comments
  resources :opinions

  # get 'users', to: 'users#index'

  root 'pages#welcome'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
