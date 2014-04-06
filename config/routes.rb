WebsiteOne::Application.routes.draw do
  get 'users/index', format: false
  root 'visitors#index', format: false
  mount Mercury::Engine => '/'

  devise_for :users, :controllers => {:registrations => 'registrations', :users => 'index'}

  #get 'users/sign_out' => redirect('/404.html')
  #get 'users/password' => redirect('/404.html')
  get 'users/:id', to: 'users#show', as: 'users_show', format: false

  get '/404', :to => 'errors#not_found', format: false
  get '/internal_server_error', :to => 'errors#internal_error', format: false

  resources :projects, format: false do
    member do
      get :follow, format: false
      get :unfollow, format: false
    end

    resources :documents, format: false do
      put :mercury_update, format: false
      get :mercury_saved, format: false
    end
  end

  resources :events, format: false do
    member do
      patch :update_only_url, format: false
    end
  end


  post 'preview/article', to: 'articles#preview', format: false
  patch 'preview/article', to: 'articles#preview', as: 'preview_articles', format: false
  resources :articles, format: false

  get 'projects/:project_id/:id', to: 'documents#show', format: false
  get '/auth/:provider/callback' => 'authentications#create', format: false
  get '/auth/failure' => 'authentications#failure'
  get '/auth/destroy/:id', to: 'authentications#destroy', via: :delete, format: false
  post 'mail_contact_form', to: 'visitors#send_contact_form', format: false
  post 'mail_hire_me_form', to: 'users#hire_me_contact_form', format: false

  put '*id/mercury_update', to: 'static_pages#mercury_update', as: 'static_page_mercury_update', format: false
  get '*id/mercury_saved', to: 'static_pages#mercury_saved', as: 'static_page_mercury_saved', format: false
  get '*id', to: 'static_pages#show', as: 'static_page', format: false
end
