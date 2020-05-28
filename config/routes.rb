Rails.application.routes.draw do

  resources :permissions
  resources :roles do
    get :duplicate
  end
  resources :follow_up_actions

  resources :follow_ups do
    post :dismiss
    post :dismiss_all, on: :collection
    post :un_dismiss
  end

  post 'rejections/dismiss' # TODO: remove this
  post 'rejections/dismiss_all' # TODO: remove this
  post 'rejections/un_dismiss' # TODO: remove this

  resources :groups do
    get :autocomplete_user_display_name, on: :collection
  end
  resources :appointees do
    get :edit_form, on: :member
  end
  resources :user_interactions, only: [:index] do
    get :daytail, on: :collection
  end
  resources :request_opinions, only: [:new, :create]
  get 'projects/edit'
  get 'projects/update'
  resources :projects, only: [:edit, :update]
  resources :accepts # TODO: obsolete
  resources :user_replies
  resources :contributions, only: [:create, :destroy]

  # patch 'proposal_to_all_board_members', to: 'invitations#proposal_to_all_board_members'
  get 'settings/update', to: 'settings#update'

  get 'appointees_chart_data', to: 'pages#appointees_chart_data'
  get 'decisions_chart_data', to: 'pages#decisions_chart_data'
  get 'welcome', as: 'welcome', to: 'pages#welcome'
  get 'dashboard', as: 'dashboard', to: 'pages#dashboard'
  get 'stats', as: 'stats', to: 'pages#stats'

  resources :invitations do
    get :update_invitation_expired_statuses, on: :collection
    get :autocomplete_display_name, on: :collection
    get :download_ics, on: :member
    get :audits, on: :member
    get :email_decoded, on: :member
    get :has_appointees, on: :member
    patch :update_participation, on: :member
    patch :cancel_participation, on: :member
    patch :update_delegation_notes, on: :member
    # patch 'want_participate', to: 'invitations#want_participate'

  end
  devise_for :users
  resources :users do
    get :search_by_name, on: :collection
    get :autocomplete_user_display_name, on: :collection
  end

  get 'comments/create'
  resources :comments
  resources :opinions

  # get 'users', to: 'users#index'

  root 'pages#welcome'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
