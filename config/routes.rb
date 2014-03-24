WebsiteOne::Application.routes.draw do
  get 'users/index'
  root 'visitors#index'
  mount Mercury::Engine => '/'

  devise_for :users, :controllers => {:registrations => 'registrations', :users => 'index'}

  #get 'users/sign_out' => redirect('/404.html')
  #get 'users/password' => redirect('/404.html')
  get 'users/:id', to: 'users#show', as: 'users_show'

  get '/404', :to => 'errors#not_found'
  get '/internal_server_error', :to => 'errors#internal_error'

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

  resources :events do
    member do
      patch :update_only_url
    end
  end


  post 'preview/article', to: 'articles#preview'
  patch 'preview/article', to: 'articles#preview', as: 'preview_articles'
  resources :articles

  get 'projects/:project_id/:id', to: 'documents#show'
  get '/auth/:provider/callback' => 'authentications#create'
  get '/auth/failure' => 'authentications#failure'
  get '/auth/destroy/:id', to: 'authentications#destroy', via: :delete
  post 'mail_contact_form', to: 'visitors#send_contact_form'
  post 'mail_hire_me_form', to: 'users#hire_me_contact_form'

  get ':id', to: 'static_pages#show', as: 'static_page'
  put ':id/mercury_update', to: 'static_pages#mercury_update', as: 'static_page_mercury_update'
  get ':id/mercury_saved', to: 'static_pages#mercury_saved', as: 'static_page_mercury_saved'
end