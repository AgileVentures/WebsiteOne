require 'spec_helper'

describe NewslettersController do

  let(:valid_attributes) { FactoryGirl.attributes_for(:newsletter) }

  let(:valid_session) { {} }
  let(:user) { @user }

  

  describe "As privilged user" do

    before :each do
      @user = get_privileged_user
      request.env['warden'].stub :authenticate => @user
      controller.stub :current_user =>  @user
    end

    describe "authorization" do
      it 'check_privileged' do
        get :new, {}, valid_session
        expect(controller.current_user.email).to be_in(Settings.privileged_users.split(','))
      end
    end

    describe "GET index" do
      it "assigns all newsletters as @newsletters" do
        newsletter = FactoryGirl.create(:newsletter) 
        get :index, {}, valid_session
        expect(assigns(:newsletters)).to eq([newsletter])
      end
    end

    describe "GET show" do
      it "assigns the requested newsletter as @newsletter" do
        newsletter = FactoryGirl.create(:newsletter)
        get :show, {:id => newsletter.to_param}, valid_session
        expect(assigns(:newsletter)).to eq(newsletter)
      end
    end

    describe "GET new" do
      it "assigns a new newsletter as @newsletter" do
        get :new, {}, valid_session
        expect(assigns(:newsletter)).to be_a_new(Newsletter)
      end

    end

    describe "GET edit" do
      it "assigns the requested newsletter as @newsletter" do
        newsletter = FactoryGirl.create(:newsletter) 
        get :edit, {:id => newsletter.to_param}, valid_session
        expect(assigns(:newsletter)).to eq(newsletter)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Newsletter" do
          expect {
            post :create, {:newsletter => valid_attributes}, valid_session
          }.to change(Newsletter, :count).by(1)
        end

        it "assigns a newly created newsletter as @newsletter" do
          post :create, {:newsletter => valid_attributes}, valid_session
          expect(assigns(:newsletter)).to be_a(Newsletter)
          expect(assigns(:newsletter)).to be_persisted
        end

        it "redirects to the created newsletter" do
          post :create, {:newsletter => valid_attributes}, valid_session
          expect(response).to redirect_to(Newsletter.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved newsletter as @newsletter" do
          Newsletter.any_instance.stub(:save).and_return(false)
          post :create, {:newsletter => { "title" => "invalid value" }}, valid_session
          expect(assigns(:newsletter)).to be_a_new(Newsletter)
        end

        it "re-renders the 'new' template" do
          Newsletter.any_instance.stub(:save).and_return(false)
          post :create, {:newsletter => { "title" => "invalid value" }}, valid_session
          expect(response).to render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested newsletter" do
          newsletter = FactoryGirl.create(:newsletter)
          expect_any_instance_of(Newsletter).to receive(:update).with({ "title" => "MyString" })
          put :update, {:id => newsletter.to_param, :newsletter => { "title" => "MyString" }}, valid_session
        end

        it "assigns the requested newsletter as @newsletter" do
          newsletter = FactoryGirl.create(:newsletter) 
          put :update, {:id => newsletter.to_param, :newsletter => valid_attributes}, valid_session
          expect(assigns(:newsletter)).to eq(newsletter)
        end

        it "redirects to the newsletter" do
          newsletter = FactoryGirl.create(:newsletter) 
          put :update, {:id => newsletter.to_param, :newsletter => valid_attributes}, valid_session
          expect(response).to redirect_to(newsletter)
        end
      end

      describe "with invalid params" do
        it "assigns the newsletter as @newsletter" do
          newsletter = FactoryGirl.create(:newsletter) 
          Newsletter.any_instance.stub(:save).and_return(false)
          put :update, {:id => newsletter.to_param, :newsletter => { "title" => "invalid value" }}, valid_session
          expect(assigns(:newsletter)).to eq(newsletter)
        end

        it "re-renders the 'edit' template" do
          newsletter = FactoryGirl.create(:newsletter) 
          Newsletter.any_instance.stub(:save).and_return(false)
          put :update, {:id => newsletter.to_param, :newsletter => { "title" => "invalid value" }}, valid_session
          expect(response).to render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested newsletter" do
        newsletter = FactoryGirl.create(:newsletter) 
        expect {
          delete :destroy, {:id => newsletter.to_param}, valid_session
        }.to change(Newsletter, :count).by(-1)
      end

      it "redirects to the newsletters list" do
        newsletter = FactoryGirl.create(:newsletter) 
        delete :destroy, {:id => newsletter.to_param}, valid_session
        expect(response).to redirect_to(newsletters_url( only_path: true))
      end
    end

  end

  describe "As unpvivileged user" do
    
    before :each do
      @user =  FactoryGirl.create(:user)
      request.env['warden'].stub :authenticate => @user
      controller.stub :current_user =>  @user
    end
   
    describe 'authorization' do
      it 'check_privilged' do
        get :new, {}, valid_session
        expect(controller.current_user.email).not_to be_in(Settings.privileged_users.split(','))
      end
    end
    describe "GET new" do
      it "renders status 403" do
        get :new, {}, valid_session
        expect(response.status).to eq(403)
      end
    end

    describe "GET edit" do
      it "renders status 403" do
        newsletter = FactoryGirl.create(:newsletter) 
        get :edit, {:id => newsletter.to_param}, valid_session
        expect(response.status).to eq(403)
      end
    end
    
    describe "DELETE destroy" do
      it "wont delete Newsletter" do
        newsletter = FactoryGirl.create(:newsletter) 
        expect {
          delete :destroy, {:id => newsletter.to_param}, valid_session
        }.to change(Newsletter, :count).by(0)
        expect(response.status).to eq(403)
      end
      
      it "renders status 403" do
        newsletter = FactoryGirl.create(:newsletter) 
        delete :destroy, {:id => newsletter.to_param}, valid_session
        expect(response.status).to eq(403)
      end
    end

    describe "PUT update" do
      it "renders status 403" do
        newsletter = FactoryGirl.create(:newsletter) 
        put :update, {:id => newsletter.to_param, :newsletter => { "title" => "MyString" }}, valid_session
        expect(response.status).to eq(403)
      end

      it "displays template 403" do
        newsletter = FactoryGirl.create(:newsletter) 
        put :update, {:id => newsletter.to_param, :newsletter => { "title" => "MyString" }}, valid_session
        expect(response).to  render_template(:file => "#{Rails.root}/public/403.html") 
      end
    end
  end

end
