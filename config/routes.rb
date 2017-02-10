Rails.application.routes.draw do
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users do
    member do
      get 'created'
      get 'saved'
      get 'in_progress'
      get 'completed'
    end
  end

  resources :list_items do
    member do
      post 'check', to: 'lists#check_item'
    end
  end

  resources :lists do
    member do
      post 'in_progress', to: 'list_users#in_progress'
      post 'completed', to: 'list_users#completed'
      post 'reset', to: 'list_users#reset'
      post 'save', to: 'list_users#save'
      post 'unsave', to: 'list_users#unsave'
    end
  end
end
