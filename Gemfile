source 'https://rubygems.org'
ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'high_voltage', '~> 3.0.0'
gem 'newrelic_rpm'
gem "rack-timeout"
gem 'inline_svg'
gem 'rails_autolink'
gem 'slack-api'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'jquery_mobile_rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'

gem "slim-rails"

gem 'remotipart', '~> 1.2'

# User authentication
gem 'devise'
gem 'devise_security_extension'
gem 'rails_email_validator'

gem 'simple_form'
gem 'carrierwave'
gem 'omniauth-facebook'
gem 'figaro'
gem "fog"
gem 'has_friendship'
gem 'will_paginate', '~> 3.1.0'
gem "letter_opener", :group => :development

gem 'rails_12factor', group: [:production]

gem 'foundation-rails'

gem 'rails-controller-testing'

# Draper gem for decorator
gem 'activemodel-serializers-xml', github: 'rails/activemodel-serializers-xml'
gem 'draper', github: 'drapergem/draper'

# For user settings
gem 'storext'

# Admin
gem 'activeadmin', '~> 1.0.0.pre4'
gem 'inherited_resources', git: 'https://github.com/activeadmin/inherited_resources'

# React.js
gem 'react-rails'

gem 'elasticsearch-model', git: 'git://github.com/elasticsearch/elasticsearch-rails.git'
gem 'elasticsearch-rails', git: 'git://github.com/elasticsearch/elasticsearch-rails.git'

gem 'rollbar'
gem 'bonsai-elasticsearch-rails'

gem 'hashids'
gem 'friendly_id', '~> 5.2.0'
gem "cocoon"
gem 'unread'
gem "mini_magick"

gem 'derailed', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'shoulda-matchers', '~> 3.1'
  gem "factory_girl_rails", "~> 4.0"
  gem 'rspec-rails', '~> 3.5'  
end

group :development do
  gem 'faker'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # detect N + 1
  gem "bullet"
  gem 'pry-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'thor', '0.19.1'
