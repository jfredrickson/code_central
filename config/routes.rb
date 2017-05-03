Rails.application.routes.draw do
  resources :code, only: [:index], controller: :projects
  resources :projects, only: [:index]
  get "pages/dashboard"
  get "pages/help"

  # Uncomment to enable crono dashboard (also, add the required gems in Gemfile)
  # mount Crono::Web, at: "/crono"

  root "pages#dashboard"
end
