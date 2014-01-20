WebsiteOne::Application.routes.draw do
  root 'visitors#index'
  mount Mercury::Engine => '/'

  devise_for :users
  # devise does not provide some GET routes, which causes routing exceptions
  get 'users' => redirect('/404.html')
  get 'users/sign_out' => redirect('/404.html')
  get 'users/password' => redirect('/404.html')

  resources :projects do
    resources :documents do
      put :mercury_update
    end
  end

end
