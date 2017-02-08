Rails.application.routes.draw do
  get 'signup' => 'users#new'
  resources :users
  resources :lists do
    resources :list_items
  end

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
end
