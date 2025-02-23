Rails.application.routes.draw do
  root to: "pages#index"

  %w{index exhibitions available sale env}.each { |p| get p => "pages##{p}" }
  get "sign_in" => "sessions#new"
  get "gallery(/:g)", to: "paintings#gallery", as: "gallery"
  (1..4).each { |g| get "/gallery#{g}", to: redirect("/gallery/#{g}") }

  resources :paintings do
    get :archive, on: :collection
  end
  resources :contacts do
    get :subscribe, on: :collection
    get :unsubscribe, on: :collection
    delete :remove, on: :member
  end
  resources :contents
  resources :exhibits do
    patch :remove, on: :member
  end
  resources :users

  resource :session, only: [:new, :create, :destroy]
  resource :otp_secret, only: [:new, :create]
end
