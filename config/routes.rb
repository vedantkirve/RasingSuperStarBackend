Rails.application.routes.draw do
  # Swagger/OpenAPI docs at /api-docs (API spec served by Api engine, UI by Ui engine)
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  # Zones APIs
  post "/zones", to: "zones#create"
  get "/zones", to: "zones#index"

  # Availability API
  get "/availability", to: "availability#index"

  # Users, Coaches, Bookings APIs
  post "/users", to: "users#create"
  post "/coaches", to: "coaches#create"
  post "/bookings", to: "bookings#create"
end
