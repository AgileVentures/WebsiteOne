require 'spec_helper'

describe ProjectsController do

  let(:valid_attributes) { {:id => 1,
                            :title => 'WebTwentyFive',
                            :description => 'My project description',
                            :status => 'Active',
                            :friendly_id => 'my-project' } }
  let(:valid_session) { {} }

  #TODO split specs into 'logged in' vs 'not logged in'
  before :each do
    # stubbing out devise methods to simulate authenticated user
    @user = double('user', id: 1, friendly_id: 'some-id')
    request.env['warden'].stub :authenticate! => @user
    controller.stub :current_user => @user
  end

  let(:user) { @user }

  #describe "pagination" do
  #  it "should paginate the feed" do
  #    visit root_path
  #    page.should have_selector("div.pagination")
  #  end
  #end


  describe '#index' do
    it 'should render index page for projects' do
      get :index
      expect(response).to render_template 'index'
    end


    it 'should assign variables to be rendered by view' do
      Project.stub(:search).and_return('Carrier has arrived.')
      get :index
      expect(assigns(:projects)).to eq 'Carrier has arrived.'
    end
  end

  describe '#show' do
    before(:each) do
      @project = mock_model(Project, valid_attributes)
      @project.stub(:tag_list).and_return [ 'WTF' ]
      Project.stub_chain(:friendly, :find).and_return @project
      @users = [ mock_model(User, friendly_id: 'my-friendly-id', display_profile: true) ]
      @more_users = @users + [ mock_model(User, friendly_id: 'another-friendly-id', display_profile: false)]
      @project.should_receive(:followers).and_return @more_users
    end

    it 'assigns the requested project as @project' do
      get :show, {:id => @project.friendly_id}, valid_session
      assigns(:project).should eq(@project)
    end

    it 'renders the show template' do
      get :show, {:id => @project.friendly_id}, valid_session
      expect(response).to render_template 'show'
    end

    it 'assigns the list of members with public profiles to @members' do
      get :show, { id: @project.friendly_id }, valid_session
      assigns(:members).should eq @users
    end

    it 'assigns the list of related YouTube videos in alphabetical order' do
      accepted_videos = [
          { title: 'WebTwentyFive PP' },
          { title: 'WTF PP'},
          { title: 'PP on WebtwentyFive'},
          { title: 'pp on wtf'},
          { title: 'A PP on WTF'},
          { title: 'My PP on WTF'},
          { title: 'webtwentyfive PP on refactoring'}
      ]
      rejected_videos = [
          { title: 'Cat Movie' },
          { title: 'Dogs and Cats' },
          { title: 'My Cats newborn' },
          { title: 'Cat Attack' }
      ]
      videos = rejected_videos + accepted_videos
      Youtube.should_receive(:user_videos).and_return videos
      get :show, { id: @project.friendly_id }, valid_session
      assigns(:videos).should eq accepted_videos.sort_by! { |v| v[:published] }
    end
  end

  describe '#new' do
    it 'should render a new project page' do
      get :new
      assigns(:project).should be_a_new(Project)
      expect(response).to render_template 'new'
    end
  end

  describe '#create' do
    before(:each) do
      @params = {
          project: {
              id: 1,
              title: 'Title 1',
              description: 'Description 1',
              status: 'Status 1'
          }
      }
      @project = mock_model(Project, friendly_id: 'some-project')
      Project.stub(:new).and_return(@project)
      controller.stub(:current_user).and_return(@user)
    end

    it 'assigns a newly created project as @project' do
      @project.stub(:save)
      post :create, @params
      expect(assigns(:project)).to eq @project
    end

    context 'successful save' do

      it 'redirects to index' do
        @project.stub(:save).and_return(true)

        post :create, @params

        expect(response).to redirect_to(projects_path)
      end
      it 'assigns successful message' do
        @project.stub(:save).and_return(true)

        post :create, @params

        #TODO YA add a show view_spec to check if flash is actually displayed
        expect(flash[:notice]).to eq('Project was successfully created.')
      end

      it 'passes current_user id into new' do
        Project.should_receive(:new).with({"title" => "Title 1", "description" => "Description 1", "status" => "Status 1", "user_id" => @user.id})
        @project.stub(:save).and_return(true)
        post :create, @params
      end
    end

    context 'unsuccessful save' do
      it 'renders new template' do
        @project.stub(:save).and_return(false)

        post :create, @params

        expect(response).to render_template :new
      end

      it 'assigns failure message' do
        @project.stub(:save).and_return(false)

        post :create, @params

        expect(flash[:alert]).to eql('Project was not saved. Please check the input.')
      end
    end
  end

  describe '#edit' do
    before(:each) do
      @project = double(Project)
      Project.stub_chain(:friendly, :find).with(an_instance_of(String)).and_return(@project)
      get :edit, id: 'some-random-thing'
    end

    it 'renders the edit template' do
      expect(response).to render_template 'edit'
    end

    it 'assigns the requested project as @project' do
      expect(assigns(:project)).to eq(@project)
    end
  end

  #  Scenarios for DESTROY action commented out until this functionality is needed
  #describe '#destroy' do
  #  before :each do
  #    @project = double(Project)
  #    Project.stub(:find).and_return(@project)
  #  end
  #  it 'receives destroy call' do
  #    expect(@project).to receive(:destroy)
  #    delete :destroy, id: 'test'
  #  end
  #
  #  context 'on successful delete' do
  #    before(:each) do
  #      @project.stub(:destroy).and_return(true)
  #      delete :destroy, id: 'test'
  #    end
  #    it 'redirects to index' do
  #      expect(response).to redirect_to(projects_path)
  #    end
  #    it 'shows the correct message' do
  #      expect(flash[:notice]).to eq 'Project was successfully deleted.'
  #    end
  #  end
  #
  #  context 'on unsuccessful delete' do
  #    before do
  #      @project.stub(:destroy).and_return(false)
  #      delete :destroy, id: 'test'
  #    end
  #    it 'redirects to index' do
  #      expect(response).to redirect_to(projects_path)
  #    end
  #    it 'shows the correct message' do
  #      expect(flash[:notice]).to eq 'Project was not successfully deleted.'
  #    end
  #  end
  #end

  describe '#update' do
    before(:each) do
      @project = mock_model(Project)
      Project.stub_chain(:friendly, :find).with(an_instance_of(String)).and_return(@project)
    end

    it 'assigns the requested project as @project' do
      @project.should_receive(:update_attributes)
      put :update, id: 'update', project: {title: ''}
      expect(assigns(:project)).to eq(@project)
    end

    context 'successful update' do
      before(:each) do
        @project.stub(:update_attributes).and_return(true)
        put :update, id: 'update', project: {title: ''}
      end

      it 'redirects to the project' do
        expect(response).to redirect_to(projects_path)
      end

      it 'shows a success message' do
        expect(flash[:notice]).to eq('Project was successfully updated.')
      end
    end

    context 'unsuccessful save' do
      before(:each) do
        @project.stub(:update_attributes).and_return(false)
        put :update, id: 'update', project: {title: ''}
      end
      it 'renders edit' do
        expect(response).to render_template(:edit)
      end

      it 'shows an unsuccessful message' do
        expect(flash[:alert]).to eq('Project was not updated.')
      end
    end
  end
end
