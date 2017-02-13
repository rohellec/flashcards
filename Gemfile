source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'coffee-rails', '4.2.1'
gem 'jbuilder', '2.6.1'
gem 'jquery-rails', '4.2.2'
gem 'pg', '0.19.0'
gem 'puma', '3.7.0'
gem 'rails', '5.0.1'
gem 'sass-rails', '5.0.6'
gem 'thor', '0.19.1'
gem 'turbolinks', '5.0.1'
gem 'uglifier', '3.0.4'

group :development, :test do
  gem 'byebug', '9.0.6', platform: :mri
end

group :development do
  gem 'listen', '3.1.5'
  gem 'spring', '2.0.1'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'web-console', '3.4.0'
end