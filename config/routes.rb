Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      resources :movies
      resources :showtimes
      resources :seats
      resources :bookings
      resources :payments
      post "/login", to: "auth#login"
      post '/register', to: 'auth#register'
    end
  end

  # Swagger UI
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
