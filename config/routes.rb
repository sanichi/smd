Rails.application.routes.draw do
  root to: "pages#index"

  %w{index exhibitions search}.each { |p| get p => "pages##{p}" }
  get "sign_in" => "sessions#new"
  get "gallery(/:g)", to: "paintings#gallery", as: "gallery"
  (1..4).each { |g| get "/gallery#{g}", to: redirect("/gallery/#{g}") }

  resources :paintings do
    get :archive, on: :collection
  end
  resources :contents
  resources :users

  resource :session, only: [:new, :create, :destroy]
end
