Rails.application.routes.draw do

  get 'api/search'

  match 'api/create', to: 'api#create', via: [:post, :put]
  match 'api/comment', to: 'api#comment', via: [:post, :put]
  match 'api/join', to: 'api#join', via: [:post, :put]
  match 'api/leave', to: 'api#leave', via: [:post, :put]

  get '/hi', to: 'session#hi'
  get '/login', to: 'session#login'
  match '/login', to: 'session#create', via: [:post]
  get '/logout', to: 'session#destroy'

  scope '/admin' do
    resources :events, :except => [:destroy]
    resources :users, :except => [:destroy]
    resources :tags, :except => [:destroy]

    get '/events/:id/destroy', to: 'events#destroy', as: 'DestroyEvent'
    get '/users/:id/destroy', to: 'users#destroy', as: 'DestroyUser'
    get '/tags/:id/destroy', to: 'tags#destroy', as: 'DestroyTag'
  end
end
