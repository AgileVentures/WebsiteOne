WebsiteOne::Application.routes.draw do
  get "users/index"
  root 'visitors#index'
  mount Mercury::Engine => '/'

  devise_for :users, :controllers => {:registrations => 'registrations', :users => 'index'}
  get 'pages/about_us' => 'high_voltage/pages#show', id: 'about_us'

  get 'users/sign_out' => redirect('/404.html')
  get 'users/password' => redirect('/404.html')
  get 'users/show/:id', to: 'users#show', as: 'users_show'
  get 'users/preview/:id', to: 'users#preview', as: 'users_preview'

  get '/auth/:provider/callback' => 'authentications#create'
  get '/auth/failure' => 'authentications#failure'

  get '/auth/destroy/:id', to: 'authentications#destroy', via: :delete

  post 'mail_contact_form', to: 'visitors#send_contact_form'

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
