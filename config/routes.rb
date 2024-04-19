Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get '/signup_choice', to: 'home#signup'
  resources :buffets, only: [:new, :create, :edit, :update, :show] do
    collection do
      get 'my_buffet'
    end
  end
  resources :events, only: [:new, :create, :show, :edit, :update, :destroy] do
    resources :prices, only: [:new, :create, :edit, :update]
  end
end
