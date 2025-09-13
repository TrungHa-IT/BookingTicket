# syntax = docker/dockerfile:1

# =========================
# Stage build (development-friendly)
# =========================
ARG RUBY_VERSION=3.2.9
FROM ruby:$RUBY_VERSION-slim AS build

WORKDIR /rails

# Cài các package cần thiết để build gem native và Rails
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential \
        make \
        gcc \
        g++ \
        default-libmysqlclient-dev \
        git \
        pkg-config \
        libyaml-dev \
        zlib1g-dev \
        libssl-dev \
        libreadline-dev \
        libffi-dev \
        nodejs \
        npm \
        libjemalloc2 \
        libvips \
        curl \
        default-mysql-client \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy Gemfile + Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Cài bundle
RUN bundle config set --local frozen false
RUN bundle install --jobs 4 --retry 3

# Copy toàn bộ code
COPY . .

# Precompile bootsnap (tăng tốc boot)
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets (production-ready)
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# =========================
# Stage production
# =========================
FROM ruby:$RUBY_VERSION-slim AS production

WORKDIR /rails

# Cài các package cơ bản để chạy Rails
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        libjemalloc2 \
        libvips \
        curl \
        default-mysql-client \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Tạo user rails an toàn
RUN groupadd --system --gid 1000 rails && \
    useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash rails

# Copy bundle và code từ stage build
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Chown cho user rails
RUN chown -R rails:rails /usr/local/bundle /rails

USER rails
WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development:test"

EXPOSE 3000

CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
