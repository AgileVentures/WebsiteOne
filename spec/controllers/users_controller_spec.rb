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
      @projects = [
          mock_model(Project, friendly_id: 'title-1', title: 'Title 1'),
          mock_model(Project, friendly_id: 'title-2', title: 'Title 2'),
          mock_model(Project, friendly_id: 'title-3', title: 'Title 3')
      ]

      @user = double('User', id: 1,
                     first_name: 'Hermionie',
                     last_name: 'Granger',
                     friendly_id: 'harry-potter',
                     email: 'hgranger@hogwarts.ac.uk',
                     display_profile: true,
                     youtube_id: 'test_id'
      )
      @user.stub(:following_by_type).and_return(@projects)
      User.stub_chain(:friendly, :find).and_return(@user)

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

    it 'assigns a user instance' do
      get 'show', id: @user.friendly_id
      expect(assigns(:user)).to eq(@user)
    end

    it 'assigns youtube videos' do
      get 'show', id: @user.friendly_id
      expect(assigns(:youtube_videos)).to eq(@youtube_videos)
    end

    it 'renders the show view' do
      get 'show', id: @user.friendly_id
      expect(response).to render_template :show
    end

    context 'with followed projects' do
      # Bryan: Empty before block?
      #before :each do
      #end

      it 'assigns a list of project being followed' do
        get 'show', id: @user.friendly_id
        expect(assigns(:users_projects)).to eq(@projects)
      end

      it 'it renders an error message when accessing a private profile' do
        @user.stub(display_profile: false)
        get 'show', id: @user.friendly_id
        expect(response).to redirect_to root_path
      end
    end
  end
end
