Rails.application.routes.draw do
  devise_for :users
  root to: 'destinations#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :destinations, only: [:index, :show]
  resources :favorites, only: [:create] do
    collection do
      get "list"
    end
  end
end
