Rails.application.routes.draw do
  devise_for :customers, path: 'customers', controllers: { sessions: "customers/sessions", registrations: "customers/registrations" }
  devise_for :users, path: 'users', controllers: { sessions: "users/sessions" }
  root to: "home#index"
  get '/signup_choice', to: 'home#signup'
  resources :buffets, only: [:new, :create, :edit, :update, :show, :index] do
    collection do
      get 'my_buffet'
      get 'search'
    end
    member do
      get 'active'
      get 'inactive'
      get 'rate'
      post 'rate', to: 'buffets#create_rate'
      get 'add_cover'
      post 'add_cover', to: 'buffets#create_add_cover'
      get 'index_ratings', to: 'buffets#index_ratings'
    end
  end
  resources :events, only: [:new, :create, :show, :edit, :update, :destroy] do
    member do
      post 'active'
      post 'inactive'
    end
    resources :prices, only: [:new, :create, :edit, :update]
    resources :albums, only: [:new, :create, :edit, :update]
    resources :orders, only: [:new, :create]
  end

  resources :orders, only: [:index, :show, :update] do
    resources :messages, only: [:index, :create, :edit, :update]
    collection do
      get 'user_index'
    end
    member do
      get 'confirm'
      get 'cancel'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :buffets, only: [:index, :show]
      resources :events, only: [:index] do
        member do
          get 'check_date'
        end
      end
    end
  end
end
