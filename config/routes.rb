Rails.application.routes.draw do
  resources :projects, only: [:index]
  get "pages/dashboard"
  get "pages/help"
  root "pages#dashboard"
end
