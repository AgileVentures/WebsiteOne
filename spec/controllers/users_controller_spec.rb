require 'spec_helper'

describe UsersController do

  describe "GET 'index'" do
    before(:each) do
      @users = [
          double('User'),
          double('User'),
          double('User'),
          double('User')
      ]
      User.should_receive(:where).and_return(@users)
    end

    it 'returns http success' do
      get 'index'
      response.should be_success
    end

    it 'assigns all users' do
    	get 'index'
    	assigns(:users).should eq @users
    end
  end

  describe "GET 'show'" do
    before :each do
      #@user = double('User')
    	@user = double('User', id: 1,
                     first_name: 'Hermionie',
                     last_name: 'Granger',
                     email: 'hgranger@hogwarts.ac.uk',
                     display_profile: true
                    )
      User.should_receive(:find).and_return(@user)
    end

    it 'assigns a user instance' do
  		get 'show', id: @user.id
  		expect(assigns(:user)).not_to be_nil
    end

    it 'renders the show view' do
      get 'show', id: @user.id
      expect(response).to render_template :show
    end

    it 'it renders an error message when accessing a private profile' do
      @user.should_receive(:display_profile).and_return(false)
      get 'show', id: @user.id
      expect(response).to redirect_to root_path
    end
  end

end
