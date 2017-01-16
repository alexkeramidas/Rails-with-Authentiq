Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create', :as => 'create_session'
  post 'auth/:provider/callback', to: 'sessions#destroy', :as => 'destroy_session'
  get 'auth/failure', to: 'sessions#auth_failure'
  root to: 'pages#index'
end
