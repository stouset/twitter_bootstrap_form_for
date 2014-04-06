Dummy::Application.routes.draw do
  root 'application#index'
  resources :users
end
