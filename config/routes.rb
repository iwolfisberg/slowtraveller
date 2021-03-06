Rails.application.routes.draw do
  devise_for :users
  root to: 'destinations#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :destinations, only: [:index, :show] do
    member do
      get "price"
    end
  end
  resources :favorites, only: [:create, :destroy] do
    collection do
      get "list"
      # delete "list/:id", to: "favorites#destroy"
    end
  end
  resources :steps, only: [:create, :update, :edit] do
    collection do
      get "traveldiary"
    end
  end
end
