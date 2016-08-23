Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'projects#index'

  resources :projects do
    resource :github_webhooks, only: :create, defaults: { formats: :json }
    resources :topics, only: [:create, :show]
  end



  require "sidekiq/web"
  authenticate :user, lambda { |u| u.name == 'maximedelpit'} do
    mount Sidekiq::Web => '/sidekiq'
  end
end
