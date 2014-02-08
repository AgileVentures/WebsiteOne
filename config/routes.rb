WebsiteOne::Application.routes.draw do
  get "users/index"
  root 'visitors#index'
  mount Mercury::Engine => '/'

  devise_for :users, :controllers => {:registrations => 'registrations', :users => 'index'}
  get 'pages/about_us' => 'high_voltage/pages#show', id: 'about_us'

  get 'users/sign_out' => redirect('/404.html')
  get 'users/password' => redirect('/404.html')
  get 'users/show/:id', to: 'users#show', as: 'users_show'

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

  get 'projects/:project_id/:id', to: 'documents#show'

  get '/auth/:provider/callback' => 'authentications#create'
  get '/auth/failure' => 'authentications#failure'

  get '/auth/destroy/:id', to: 'authentications#destroy', via: :delete

  post 'mail_contact_form', to: 'visitors#send_contact_form'


end
