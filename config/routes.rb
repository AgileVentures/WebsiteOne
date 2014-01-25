WebsiteOne::Application.routes.draw do
  root 'visitors#index'
  mount Mercury::Engine => '/'

  devise_for :users, :controllers => {:registrations => 'registrations'}
  # devise does not provide some GET routes, which causes routing exceptions
  get 'users' => redirect('/404.html')
  get 'users/sign_out' => redirect('/404.html')
  get 'users/password' => redirect('/404.html')

  get '/auth/:provider/callback' => 'authentications#create'
  get '/auth/failure' => 'authentications#failure'

  get '/auth/:id', to: 'authentications#destroy', via: :delete

  resources :projects do
    resources :documents do
      put :mercury_update
      get :mercury_saved
    end
  end

end
