Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get '/signup_choice', to: 'home#signup'
  resources :buffets, only: [:new, :create, :edit, :update] do
    collection do
      get 'my_buffet'
    end
  end
end
