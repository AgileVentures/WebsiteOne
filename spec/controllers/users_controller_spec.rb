require 'spec_helper'

describe UsersController do

  describe "GET 'index'" do

    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "assigns all users" do
    	pending
    	get 'index'
    	# assigns(:users).should
    end
  end

  describe "GET 'show'" do
    before :each do
      #@user = double('User')
    	@user = double('User', id: 1, first_name: 'Hermionie', last_name: 'Granger', email: 'hgranger@hogwarts.ac.uk')
      User.stub(find: @user)
    end
    it "assigns a user instance" do
  		get 'show', id: @user.id
  		expect(assigns(:user)).not_to be_nil
    end
    it "renders the show view" do
      get 'show', id: @user.id
      expect(response).to render_template :show
    end
  end

end
