Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'

  resources :projects do
    resource :github_webhooks, only: :create, defaults: { formats: :json }
  end
  resources :topics, only: [:create, :show]


  require "sidekiq/web"
  authenticate :user, lambda { |u| u.name == 'maximedelpit'} do
    mount Sidekiq::Web => '/sidekiq'
  end
end
