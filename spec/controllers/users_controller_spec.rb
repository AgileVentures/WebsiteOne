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
      expect(response).to render_template 'index'
    end

    it 'assigns all users' do
    	get 'index'
    	assigns(:users).should eq @users
    end
  end

  describe 'GET show' do
    before :each do
      @user = double('User', id: 1,
                     first_name: 'Hermionie',
                     last_name: 'Granger',
                     email: 'hgranger@hogwarts.ac.uk',
                     display_profile: true,
                     youtube_id: 'test_id'
      )
      User.should_receive(:find).and_return(@user)
    end

    it 'assigns a user instance' do
  		get 'show', id: @user.id
  		expect(assigns(:user)).not_to be_nil
    end

    it 'renders the show view' do
      User.stub(find: @user)

      @youtube_videos = [
          {
              url: "http://www.youtube.com/100",
              title: "Random",
              published: '01/01/2015'
          },
          {
              url: "http://www.youtube.com/340",
              title: "Stuff",
              published: '01/01/2015'
          },
          {
              url: "http://www.youtube.com/2340",
              title: "Here's something",
              published: '01/01/2015'
          }
      ]
      Youtube.stub(user_videos: @youtube_videos)

    end
    it "assigns a user instance" do
      get 'show', id: @user.id
      expect(assigns(:user)).not_to be_nil
    end

    it 'assigns youtube videos' do
      get 'show', id: @user.id
      expect(assigns(:youtube_videos)).to eq(@youtube_videos)
    end

    it "renders the show view" do
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
