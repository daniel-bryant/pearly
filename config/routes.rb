Pearly::Engine.routes.draw do
  resources :tokens, only: [:create]
end
