Rails.application.routes.draw do
  root to: "pages#index"

  %w{index note}.each { |p| get p => "pages##{p}" }
end
