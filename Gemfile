source 'https://rubygems.org'
ruby '2.3.0'

gem 'rails', '5.0.0'
gem 'puma'
gem 'pg'
gem 'figaro'
gem 'jbuilder', '~> 2.0'

# Authentication
gem 'devise', github: 'plataformatec/devise'
gem 'omniauth-github'
gem "octokit", "~> 4.0"

gem 'redis'
gem 'redis-namespace'
gem 'sidekiq'
gem 'sinatra', github: 'sinatra/sinatra'  # Dependency for the Sidekiq Dashboard
gem 'sidekiq-failures'

gem 'sass-rails'
gem 'jquery-rails'
gem 'uglifier'
gem 'materialize-sass'
gem 'font-awesome-sass'
gem 'simple_form', github: 'plataformatec/simple_form'
gem 'autoprefixer-rails'
gem 'rails-assets-jstree', source: 'https://rails-assets.org'




# STI relations for specs
gem 'ancestry'

# State Machines
gem 'statesman', '~> 2.0', '>= 2.0.1'

# cache octokit
# gem 'faraday-http-cache'

group :development, :test do
  # debug
  gem 'binding_of_caller'
  gem 'better_errors'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'spring'
  gem 'listen', '~> 3.0.5'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # tests
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'capybara'
  gem 'poltergeist'
  gem 'launchy'
  gem 'webmock'
end

group :test do
  gem 'database_cleaner', '~> 1.5'
  gem 'shoulda-matchers', '~> 3.1'
end
# group :production do
#   gem 'rails_12factor'
# end
