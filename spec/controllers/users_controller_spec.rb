require 'spec_helper'

describe UsersController do

  describe "GET 'index'" do
  	# before :all do
  	# 	@user = mock_model(:user)

  	# end

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
  	it "assigns a user instance" do
  		pending
  		get 'show'
  		assigns(:user).should_not be_nil
  	end
  end

end
