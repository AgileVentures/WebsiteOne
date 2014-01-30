WebsiteOne::Application.routes.draw do
  get "users/index"
  root 'visitors#index'
  mount Mercury::Engine => '/'

  devise_for :users, :controllers => {:registrations => 'registrations', :users => 'index'}
  get 'pages/about_us' => 'high_voltage/pages#show', id: 'about_us'

  get 'users/sign_out' => redirect('/404.html')
  get 'users/password' => redirect('/404.html')

  get '/auth/:provider/callback' => 'authentications#create'
  get '/auth/failure' => 'authentications#failure'

  get '/auth/destroy/:id', to: 'authentications#destroy', via: :delete

  resources :projects do
    member do
      get :follow
      get :unfollow
    end
    resources :documents do
      put :mercury_update
      get :mercury_saved
    end
  end

end
