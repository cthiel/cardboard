source 'http://rubygems.org'

gem 'rails', '~> 3.1.1.rc1'

# http://devcenter.heroku.com/articles/how-do-i-use-sqlite3-for-development
group :production do
  gem 'pg'
end
group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem "jasminerice"
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
gem 'formtastic', :git => 'git://github.com/justinfrench/formtastic.git'
gem 'acts-as-taggable-on', :git => 'git://github.com/mbleigh/acts-as-taggable-on.git'
gem 'paper_trail'
gem 'acts_as_list'
gem 'friendly_id', "~> 4.0.0.beta8"
