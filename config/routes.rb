Rails.application.routes.draw do
  root 'connections#index'

  delete "/logout" => "session#destroy", as: :logout
  get "/auth/:provider/callback" => "session#create"

  resources :connections
  post '/search_result' => 'connections#search_result'

end
