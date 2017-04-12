Rails.application.routes.draw do
  resources :projects, only: [:index]
  get "pages/help"
  root "projects#index"
end
