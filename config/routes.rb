WebsiteOne::Application.routes.draw do

  devise_for :users, :controllers => {
                                        registrations: 'users/registrations',
                                        sessions: 'users/sessions'
                                    }

  root 'visitors#index'

  resources :projects do
    resources :documents
  end

end
