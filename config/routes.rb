Rails.application.routes.draw do
  scope '/admin' do
  	resources :events
  	resources :users
  end
end
