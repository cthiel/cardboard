source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# http://devcenter.heroku.com/articles/how-do-i-use-sqlite3-for-development
group :production do
  gem 'pg'
end
group :development, :test do
  gem 'sqlite3'
end

gem 'json'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.0.rc"
  gem 'coffee-rails', "~> 3.1.0.rc"
  gem 'execjs'
  gem 'therubyracer'
  gem 'uglifier'
end

gem 'haml'
gem 'jquery-rails'
gem 'formtastic'
gem 'acts-as-taggable-on', :git => 'git://github.com/mbleigh/acts-as-taggable-on.git'
gem 'paper_trail'
gem 'acts_as_list'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

gem "rspec-rails", :group => [:test, :development]
#group :test do
#  gem "factory_girl_rails"
#  gem "capybara"
#end
