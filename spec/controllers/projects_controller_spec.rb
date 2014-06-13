require 'spec_helper'

describe ProjectsController do

  let(:valid_attributes) { {:id => 1,
                            :title => 'WebTwentyFive',
                            :description => 'My project description',
                            :status => 'Active',
                            :pivotaltracker_url => 'https://www.pivotaltracker.com/s/projects/982890',
                            :friendly_id => 'my-project' } }
  let(:valid_session) { {} }

  #TODO split specs into 'logged in' vs 'not logged in'
  before :each do
    # stubbing out devise methods to simulate authenticated user
    #@user = double('user', id: 1, friendly_id: 'some-id')
    @user = FactoryGirl.create(:user, id: 1, slug: 'some-id')
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
      @project.should_receive(:members).and_return @users
      @project.stub(videos: 'videos')
      PivotalService.stub(one_project: '') 
      dummy = Object.new
      dummy.stub(stories: "stories")
      PivotalService.stub(iterations: dummy)
      @project.stub(pivotaltracker_url?: true)
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

    it 'assigns the list of related YouTube videos' do
      get :show, { id: @project.friendly_id }, valid_session
      expect(assigns(:videos)).to eq 'videos'
    end

    it 'assigns the list of related PivtalTracker stories' do
      get :show, { id: @project.friendly_id }, valid_session
      expect(assigns(:stories)).to eq 'stories'
    end

    it 'notifies ExceptionNotifier when error occurs in fetching of PivotalTracker stories' do
      PivotalService.stub(:iterations).and_raise(StandardError)
      ExceptionNotifier.should_receive(:notify_exception)
      get :show, { id: @project.friendly_id }, valid_session
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
      controller.stub(:current_user).and_return(@user)
    end

    context 'successful save' do
      it 'creates a new Project' do
        expect {
          post :create, @params
        }.to change(Project, :count).by(1)
      end

      it "assigns a newly created project as @project" do
        post :create, @params
        assigns(:project).should be_a(Project)
        assigns(:project).should be_persisted
      end

      it "redirects to the created post" do
        post :create, @params
        response.should redirect_to(Project.last)
      end

      it 'assigns successful message' do
        post :create, @params
        expect(flash[:notice]).to eq('Project was successfully created.')
      end

      it 'it creates the project for the current_user' do
        post :create, @params
        expect(assigns(:project).user_id).to eq @user.id
      end
    end

    context 'unsuccessful save' do
      it "assigns a newly created but unsaved project as @project" do
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        post :create, @params
        assigns(:project).should be_a_new(Project)
      end

      it "re-renders the 'new' template and assigns failure message" do
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        post :create, @params
        response.should render_template("new")
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
        expect(response).to redirect_to(project_path(@project))
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

  describe '#follow' do
    before do
      @project = mock_model(Project, valid_attributes)
      Project.stub_chain(:friendly, :find).and_return @project
      controller.stub(:current_user).and_return(@user)
    end

    it 'assigns the requested project as @project' do
      @user.should_receive(:follow)
      get :follow, id: 'follow', project: {title: ''}
      expect(assigns(:project)).to eq(@project)
    end

    context 'logged in' do
      it 'current user should follow project' do
        @user.should_receive(:follow).with(@project)
        get :follow, id: 'follow', project: {title: ''}
      end

      it 'should redirect to project show page and show successful flash notice' do
        @user.stub(:follow)
        get :follow, id: 'follow', project: {title: ''}
        expect(response).to redirect_to(project_path(@project))
        expect(flash[:notice]).to eq "You just joined #{@project.title}."
      end
    end

    context 'not logged in' do
      before do
        @user.stub(:follow)
        controller.stub(current_user: nil)
      end

      it 'should show a flash notice saying user must be signed in' do
        get :follow, id: 'follow', project: {title: ''}
        expect(flash[:error]).to eq "You must <a href='/users/sign_in'>login</a> to follow #{@project.title}."
      end
    end
  end

  describe '#unfollow' do
    before do
      @project = mock_model(Project, valid_attributes)
      Project.stub_chain(:friendly, :find).and_return @project
      controller.stub(:current_user).and_return(@user)
    end

    it 'assigns the requested project as @project' do
      @user.should_receive(:stop_following)
      get :unfollow, id: 'unfollow', project: {title: ''}
      expect(assigns(:project)).to eq(@project)
    end

    context 'logged in' do
      it 'current user should unfollow project' do
        @user.should_receive(:stop_following).with(@project)
        get :unfollow, id: 'unfollow', project: {title: ''}
      end

      it 'should redirect to project show page and show successful flash notice' do
        @user.stub(:stop_following)
        get :unfollow, id: 'unfollow', project: {title: ''}
        expect(response).to redirect_to(project_path(@project))
        expect(flash[:notice]).to eq "You are no longer a member of #{@project.title}."
      end
    end

    context 'not logged in' do
      before do
        @user.stub(:follow)
        controller.stub(current_user: nil)
      end

      it 'should show a flash notice saying user must be signed in' do
        get :unfollow, id: 'unfollow', project: {title: ''}
        expect(flash[:error]).to eq "You must <a href='/users/sign_in'>login</a> to unfollow #{@project.title}."
      end
    end
  end
end
