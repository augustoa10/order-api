source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 6.0.2.1"
# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"
# Use Puma as the app server
gem "puma", "~> 4.1"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

# A data migration library, similar to rails built-in schema migration.
gem "seed_migration"

# CPF & CNPJ generator, validator & formatter
gem "cpf_cnpj"

# HTTP client library that provides a common interface over many adapters
gem "faraday", "~> 0.17.3"
gem "faraday_middleware", "~> 0.14.0"

# Attributes for Plain Old Ruby Objects
gem "virtus"

group :development, :test do
  gem "pry-rails"
  gem "pry-remote"
end

group :development do
  # Access an interactive console on exception pages or by calling "console" anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-its"
  gem "rspec-rails"
  gem "simplecov", require: false
  gem "webmock", "~> 3.4"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
