module StaticPages
  class API < Grape::API
    version 'v1', using: :path, vendor: 'agileventures'
    format :json
    prefix :api
    
    resource '/static-pages' do
      desc 'Membership plans page'
      get '/membership-plans' do
        membership_plan = StaticPage.find_by slug: 'membership-plans'
        membership_plan.body
      end
      
      desc 'Premium page'
      get :premium do
        membership_plan = StaticPage.find_by title: 'Premium Membership'
        membership_plan.body
      end
      
      desc 'Premium Mob page'
      get :premiummob do
        membership_plan = StaticPage.find_by title: 'Premium Mob'
        membership_plan.body
      end
      
      desc 'Premium F2F page'
      get :premiumf2f do
        membership_plan = StaticPage.find_by title: 'Premium F2F'
        membership_plan.body
      end
      
      desc 'About us page'
      get '/about-us' do
        membership_plan = StaticPage.find_by title: 'About Us'
        membership_plan.body
      end
      
      desc 'Getting Started page 1'
      get '/getting-started' do
        membership_plan = StaticPage.find_by slug: 'getting-started'
        membership_plan.body
      end

      desc 'Getting Started page 2'
      get '/getting-started-2' do
        membership_plan = StaticPage.find_by title: 'Getting Started 2 (of 7)'
        membership_plan.body
      end

      desc 'Getting Started page 3'
      get '/getting-started-3' do
        membership_plan = StaticPage.find_by title: 'Getting Started 3 ( 7)'
        membership_plan.body
      end

      desc 'Getting Started page 4'
      get '/getting-started-4' do
        membership_plan = StaticPage.find_by title: 'Getting Started 4 (of 7)'
        membership_plan.body
      end

      desc 'Getting Started page 5'
      get '/getting-started-5' do
        membership_plan = StaticPage.find_by title: 'Getting Started 5 (of 7)'
        membership_plan.body
      end

      desc 'Getting Started page 6'
      get '/getting-started-6' do
        membership_plan = StaticPage.find_by title: 'Getting Started 6 (of 7)'
        membership_plan.body
      end

      desc 'Getting Started page 7'
      get '/getting-started-7' do
        membership_plan = StaticPage.find_by title: 'Getting Started 7 (of 7)'
        membership_plan.body
      end
    end
  end
end