WebsiteOne::Application.routes.draw do

  mount Mercury::Engine => '/'

  devise_for :users

  root 'visitors#index'

  resources :projects do
    resources :documents do
      put :mercury_update
    end
  end

end
