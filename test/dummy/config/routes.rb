Rails.application.routes.draw do
  mount Pearly::Engine => "/pearly"

  resources :rappers, only: [:index]
end
