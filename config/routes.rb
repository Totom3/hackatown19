Rails.application.routes.draw do

  get '/hi', to: 'session#hi'
  get '/login', to: 'session#login'
  match '/login', to: 'session#create', via: [:post]
  get '/logout', to: 'session#destroy'

  scope '/admin' do
    resources :events
    resources :users
    resources :tags    
  end
end
