module StaticPages
  class API < Grape::API
    version 'v1', using: :path, vendor: 'agileventures'
    format :json
    prefix :api
    
    resource '/static-pages' do
      desc 'Membership plans page'
      get '/membership-plans' do
        membership_plan = StaticPage.find 7
        membership_plan.body
      end
      
      desc 'Premium page'
      get :premium do
        membership_plan = StaticPage.find 20
        membership_plan.body
      end
      
      desc 'Premium Mob page'
      get :premiummob do
        membership_plan = StaticPage.find 17
        membership_plan.body
      end
      
      desc 'Premium F2F page'
      get :premiumf2f do
        membership_plan = StaticPage.find 8
        membership_plan.body
      end
      
      desc 'About us page'
      get '/about-us' do
        membership_plan = StaticPage.find 16
        membership_plan.body
      end
      
      desc 'Getting Started page'
      get '/getting-started' do
        membership_plan = StaticPage.find 4
        membership_plan.body
      end
    end
  end
end