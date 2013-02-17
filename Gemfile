source 'http://rubygems.org'

gem 'rails', '3.2.12'

# http://devcenter.heroku.com/articles/how-do-i-use-sqlite3-for-development
group :production do
  gem 'pg'
  gem 'therubyracer-heroku'
end
group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'

  gem 'libv8'
  gem 'therubyracer', '~> 0.11.3'
end

gem 'json'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   "~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'execjs'
  gem 'uglifier',     ">= 1.0.3"
end

gem 'haml'
gem 'jquery-rails'
gem 'formtastic'
gem 'acts-as-taggable-on', :git => 'git://github.com/mbleigh/acts-as-taggable-on.git'
gem 'paper_trail'
gem 'acts_as_list'
gem 'friendly_id'
