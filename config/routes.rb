Rails.application.routes.draw do
  get 'project_states/update'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'projects#index'

  resources :projects do
    resource :github_webhooks, only: :create, defaults: { formats: :json }
    resources :topics, only: [:create, :show]
    resources :project_states, only: :update
  end



  require "sidekiq/web"
  authenticate :user, lambda { |u| u.name == 'maximedelpit'} do
    mount Sidekiq::Web => '/sidekiq'
  end
end
