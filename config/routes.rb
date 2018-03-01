Rails.application.routes.draw do
  get 'pages/index'
  post 'pages/index'
  get 'pages/original_file'
  post 'pages/original_file'
  resources :pages

  root to: 'pages#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
