WebsiteOne::Application.routes.draw do

  devise_for :users, :controllers => { registrations: 'users/registrations' }

  root 'visitors#index'

  resources :projects
end
