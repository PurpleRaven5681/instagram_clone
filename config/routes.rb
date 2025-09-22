Rails.application.routes.draw do
  devise_for :users
  
  root 'posts#index'
  
  resources :posts do
    member do
      post :like
      post :unlike
    end
    collection do
      get :search
    end
  end
  
  resources :users, only: [:show] do
    member do
      post :follow
      post :unfollow
    end
  end
end
