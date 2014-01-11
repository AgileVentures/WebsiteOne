require 'spec_helper'

describe ProjectsController do
  let(:valid_attributes) { { :title => '"Title',
                             :description => 'Description',
                             :status => 'active' } }
  let(:valid_session) { {} }

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

  context '#show, #edit, #update, #destroy' do
    before(:each) do
    end

      it 'should delete a project' do
        project = double(Project)
        Project.stub(:find).and_return(project)

        expect(project).to receive(:destroy)
        delete :destroy, {:id => 'test'}
      end

  end
end
