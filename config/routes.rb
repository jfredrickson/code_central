Rails.application.routes.draw do
  resources :code, only: [:index], controller: :projects
  resources :projects, only: [:index]
  get "pages/dashboard"
  get "pages/help"
  root "pages#dashboard"
end
