Rails.application.routes.draw do
  root 'webhook#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post '/sendmessage', to: 'webhook#sendmessage'
  post '/webhook', to: 'webhook#hook'
end
