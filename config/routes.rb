Birds::Application.routes.draw do
  resources :birds


  # scaffold resources
    resources :authorizations
    resources :users

  get "welcome/index"

  root :to => 'welcome#index'

  match '/image', :to => 'birds#image'

  #omniauth
    get   '/login', :to => 'sessions#new', :as => :login
    match '/auth/:provider/callback', :to => 'sessions#create'
    match '/auth/failure', :to => 'sessions#failure'
    get '/logout', :to => 'sessions#destroy', :as => :logout

end
