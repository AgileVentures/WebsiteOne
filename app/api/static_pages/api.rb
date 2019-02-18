module StaticPages
  class API < Grape::API
    version 'v1', using: :path, vendor: 'agileventures'
    format :json
    prefix :api

    resource '/static-pages' do
      desc 'Getting Started page'
      get '/getting-started' do
        StaticPage.find 4
      end

      desc 'Premium F2F page'
      get :premiumf2f do
        StaticPage.find 8
      end
      
      desc 'About us page'
      get '/about-us' do
        StaticPage.find 16
      end

      desc 'Premium Mob page'
      get :premiummob do
        StaticPage.find 17
      end

      desc 'Premium page'
      get :premium do
        StaticPage.find 20
      end

      desc 'Membership plans page'
      get '/membership-plans' do
        StaticPage.find 7
      end
    end
  end
end