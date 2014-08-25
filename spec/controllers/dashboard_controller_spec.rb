require 'spec_helper'

describe DashboardController, type: :controller do

   describe "GET index" do

     it "renders the correct template" do
       get :index
       expect(response).to render_template 'dashboard/index'
     end

     it "assigns stats variable" do
        allow(controller).to receive(:get_stats).and_return('test')
        get :index
        expect(assigns(:stats)).to eq 'test'
     end

     describe "gets stats for" do
     end
   end

   # describe "computes interesting statistics" do
   #
   #   it "counts articles" do
   #     allow(Article).to receive(:count).and_return(10)
   #     expect(controller.get_article_count[:articles][:count]).to eq 10 
   #   end
   #
   #   it "counts projects" do
   #     allow(Project).to receive(:count).and_return(10)
   #     expect(controller.get_project_count[:projects][:count]).to eq 10 
   #   end
   #
   #   it "counts members" do
   #     allow(User).to receive(:count).and_return(10)
   #     expect(controller.get_member_count[:members][:count]).to eq 10 
   #   end
   #   
   #   xit "finds the most popular projects" do
   #   end
   #
   #   xit "finds the top contributors" do
   #   end
   # end

end 
