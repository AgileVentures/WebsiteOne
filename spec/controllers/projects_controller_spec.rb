require 'spec_helper'

describe ProjectsController do

  let(:valid_attributes) { { :title => 'MyProject',
                             :description => 'My project description',
                             :status => 'Active' } }
  let(:valid_session) { {} }

  #TODO split specs into 'logged in' vs 'not logged in'
  before :each do
    # stubbing out devise methods to simulate authenticated user
    user = double('user')
    request.env['warden'].stub :authenticate! => user
    controller.stub :current_user => user
  end

  describe '#index' do
    it 'should render index page for projects' do
      get :index
      expect(response).to render_template 'index'
    end

    it 'should assign variables to be rendered by view' do
      projects = [double(Project), double(Project)]
      Project.stub(:order).and_return(projects)
      get :index
      expect(assigns(:projects)).to eq projects
    end
  end

  describe '#show' do
    before(:each) do
      @project = Project.create! valid_attributes
      get :show, {:id => @project.id}, valid_session
    end

    it 'assigns the requested project as @project' do
      assigns(:project).should eq(@project)
    end

    it 'renders the show template' do
      expect(response).to render_template 'show'
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
      @user = mock_model(User, id: 1)
      @project = mock_model(Project, id: 1)
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
        Project.should_receive(:new).with({"title"=>"Title 1", "description"=>"Description 1", "status"=>"Status 1", "user_id" => @user.id})
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
      Project.stub(:find).and_return(@project)
      get :edit, id: 'show'
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
      Project.stub(:find).and_return(@project)
    end

    it 'assigns the requested project as @project' do
      @project.stub(:update_attributes)
      put :update, id: 'update', project: { title: ''}
      expect(assigns(:project)).to eq(@project)
    end

    context 'successful update' do
      before(:each) do
        @project.stub(:update_attributes).and_return(true)
        put :update, id: 'update', project: { title: ''}
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
        put :update, id: 'update', project: { title: ''}
      end
      it 'renders edit' do
        expect(response).to render_template(:edit)
      end

      it 'shows an unsuccessful message' do
        expect(flash[:alert]).to eq('Project was not updated.')
      end
    end
  end

  it 'shows a notice if requested action for non-existing project ' do
    get :edit,  id: 'non-existent'
    expect(flash[:alert]).to eq('Requested action failed.  Project was not found.')
    expect(response).to redirect_to(projects_path)
  end

end
