require 'spec_helper'

describe ProjectsController do
  #TODO split specs into 'logged in' vs 'not logged in'
  before :each do
    user = double('user')
    request.env['warden'].stub :authenticate! => user
    controller.stub :current_user => user
  end

  it 'should render index page for projects' do
    get :index
    expect(response).to render_template 'index'
  end

  it 'should assign variables to be rendered by view' do
    projects = [ double(Project), double(Project) ]
    Project.stub(:all).and_return(projects)
    get :index
    expect(assigns(:projects)).to eq projects
  end

  it 'should render a new project page' do
    get :new
    expect(response).to render_template 'new'
  end

  it 'should notice if the project does not exist' do
    @project = Project.new
    delete :destroy, { :id => 'nonexistent project' }
    expect(response).to redirect_to(projects_path)
    expect(flash[:notice]).to eq 'Project not found.'
  end

  context '#destroy' do


    before :each do
      @project = double(Project)
      Project.stub(:find).and_return(@project)
    end
    it 'should delete a project' do
      expect(@project).to receive(:destroy)
      delete :destroy, { :id => 'test' }
    end
    it 'should redirect to the index' do
      allow(@project).to receive(:destroy)
      delete :destroy, { :id => 'test' }
      expect(response).to redirect_to(projects_path)
    end

  end
end
