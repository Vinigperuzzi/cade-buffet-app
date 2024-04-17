Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get '/signup_choice', to: 'home#signup'
end
