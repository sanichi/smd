Rails.application.routes.draw do
  root to: "pages#index"

  %w{index exhibitions search}.each { |p| get p => "pages##{p}" }
  get "sign_in" => "sessions#new"
  (1..4).each { |p| get "gallery#{p}" => "pages#gallery#{p}" }

  resources :users
  resource :session, only: [:new, :create, :destroy]
end
