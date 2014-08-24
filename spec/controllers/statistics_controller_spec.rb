require 'spec_helper'

describe StatisticsController, :type => :controller do

   describe "GET index" do
     before(:each) { get :index } 

     it "renders the correct template" do
       expect(response).to render_template 'dashboard/index'
     end
   end

   describe "computes interesting statistics" do

     it "counts articles" do
       allow(Article).to receive(:count).and_return(10)
       expect(controller.get_article_count[:articles][:count]).to eq 10 
     end

     it "counts projects" do
       allow(Project).to receive(:count).and_return(10)
       expect(controller.get_project_count[:projects][:count]).to eq 10 
     end

     it "counts members" do
       allow(User).to receive(:count).and_return(10)
       expect(controller.get_member_count[:members][:count]).to eq 10 
     end
     
     xit "finds the most popular projects" do
     end

     xit "finds the top contributors" do
     end
   end

end 
