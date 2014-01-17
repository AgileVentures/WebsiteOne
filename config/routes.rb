WebsiteOne::Application.routes.draw do

  mount Mercury::Engine => '/'
  resources :documents do
    put :mercury_update
  end

  devise_for :users

  root 'visitors#index'

  resources :projects do
    resources :documents
  end

end
