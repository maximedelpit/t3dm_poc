Rails.application.routes.draw do
  get 'project_states/update'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'projects#index'

  resources :projects do
    resource :github_webhooks, only: :create, defaults: { formats: :json }
    resources :topics, only: [:create, :show, :update] do
      resources :comments, shallow: true, only: [:create, :update]
    end
    resources :project_states, only: :update
    resources :orders, only: [:create, :update]
    member do
      get 'file/:sha', to: 'repositories#show'
    end
  end

  resources :order_lines, only: :destroy
  resources :meetings

  require "sidekiq/web"
  mount Sidekiq::Web => '/sidekiq'


  mount Attachinary::Engine => "/attachinary"
  mount ActionCable.server => '/cable'

end
