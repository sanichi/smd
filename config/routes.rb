Rails.application.routes.draw do
  root to: "pages#index"
  %w{index exhibitions}.each { |p| get p => "pages##{p}" }
  (1..4).each { |p| get "gallery#{p}" => "pages#gallery#{p}" }
end
