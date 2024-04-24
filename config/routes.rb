Rails.application.routes.draw do
  devise_for :customers, path: 'customers', controllers: { sessions: "customers/sessions" }
  devise_for :users, path: 'users', controllers: { sessions: "users/sessions" }
  root to: "home#index"
  get '/signup_choice', to: 'home#signup'
  resources :buffets, only: [:new, :create, :edit, :update, :show, :index] do
    collection do
      get 'my_buffet'
      get 'search'
    end
  end
  resources :events, only: [:new, :create, :show, :edit, :update, :destroy] do
    resources :prices, only: [:new, :create, :edit, :update]
  end
end
