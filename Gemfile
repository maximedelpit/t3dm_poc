source 'https://rubygems.org'
ruby '2.4.1'

gem 'rails', '5.0.0'
gem 'puma'
gem 'pg'
gem 'figaro'
gem 'jbuilder', '~> 2.0'

# Authentication
gem 'devise', github: 'plataformatec/devise'
gem 'omniauth-github'

# # Authorization
gem "pundit"

gem "octokit", "~> 4.0"
gem 'github_webhook', '~> 0.5.0'

gem 'redis'
gem 'redis-namespace'
gem 'sidekiq'
gem 'sinatra', github: 'sinatra/sinatra'  # Dependency for the Sidekiq Dashboard
gem 'sidekiq-failures'

gem 'sass-rails'
gem 'jquery-rails'
gem 'uglifier'
gem 'materialize-sass'
gem 'materialize-form'
gem 'font-awesome-sass'
gem 'autoprefixer-rails'
# gem 'sweetalert-rails'
gem 'rails-assets-sweetalert2', source: 'https://rails-assets.org'
gem 'rails-assets-jstree', source: 'https://rails-assets.org'
gem 'rails-assets-clockpicker', source: 'https://rails-assets.org'
gem 'rails-assets-Chart-js', source: 'https://rails-assets.org'

# forms
gem 'simple_form', github: 'plataformatec/simple_form'
gem 'cocoon'

# STI relations for specs
gem 'ancestry'

# State Machines
gem 'statesman', '~> 2.0', '>= 2.0.1'

# File upload
# wait for PR 151 to be merged => https://github.com/JangoSteve/remotipart/pull/151
gem 'remotipart', github: 'mshibuya/remotipart'
gem "cloudinary", "1.1.0"
gem "attachinary", github: "assembler/attachinary"
gem "jquery-fileupload-rails"
gem "coffee-rails"

# Notiffications
gem 'icalendar', '~> 2.2.2'
gem 'public_activity'

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
