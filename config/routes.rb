Rails.application.routes.draw do
  get 'pages/welcome', as: 'welcome'
  get 'pages/dashboard', as: 'dashboard'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
