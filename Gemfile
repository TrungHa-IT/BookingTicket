source "https://rubygems.org"

# ===== Core gems =====
gem 'jwt'
gem 'rqrcode'
gem "rails", "~> 7.2.2", ">= 7.2.2.2"
gem "mysql2", "~> 0.5"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "faker", "~> 2.23"
gem "kaminari"
gem "annotate"
gem "sprockets-rails"

# Optional/OS-specific
gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false

# ===== Development & Test =====
group :development, :test do
  gem "debug" # Không require debug/prelude, tránh lỗi Docker/Linux
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

# ===== Development only =====
group :development, :test do
  gem "rspec-rails"
  gem "rswag-api"
  gem "rswag-ui"
  gem "rswag-specs"
end


# ===== Test only =====
group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
