Rails.application.routes.draw do
  root 'landing#index'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'home' => 'home#in_progress'
  get 'home/completed' => 'home#completed'
  get 'home/saved' => 'home#saved'
  get 'home/created' => 'home#created'
  get 'home/backlog' => 'home#backlog'
  get 'recent' => 'explore#recent'
  get 'popular' => 'explore#popular'
  get 'settings' => 'users#edit'

  resources :account_activations, only: [:edit]

  resources :users, except: [:index, :edit], param: :username do
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
