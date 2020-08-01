Rails.application.routes.draw do

  resources :work_types
  resources :businesses do
    resources :reviews
    resources :business_hours
  end
end
