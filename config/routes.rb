WebsiteOne::Application.routes.draw do

  devise_for :users

  root 'visitors#index'

  resources :projects do
    resources :documents
  end

end
