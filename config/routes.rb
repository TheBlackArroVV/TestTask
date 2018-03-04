Rails.application.routes.draw do
  # resources :pages
  get 'pages/index'
  post 'pages/index'

  root to: 'pages#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
