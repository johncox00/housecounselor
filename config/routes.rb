Rails.application.routes.draw do

  resources :work_types
  resources :businesses do
    resources :reviews
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
