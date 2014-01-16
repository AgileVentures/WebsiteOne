WebsiteOne::Application.routes.draw do

  resources :documents

  devise_for :users

  root 'visitors#index'

  resources :projects do
    resources :documents
  end

end
