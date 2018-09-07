Rails.application.routes.draw do
  root 'webhook#home'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/sendmessage', to: 'webhook#sendMessage'
end
