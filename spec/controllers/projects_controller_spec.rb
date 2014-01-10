require 'spec_helper'

describe ProjectsController do
  it 'should render index page for projects' do
    get :index
    expect(response).to render_template 'projects'
  end
  
  it 'should assign variables to be rendered by view' do
    projects = [ double(Project), double(Project) ]
    Project.stub(:all).and_return(projects)
    get :index
    expect(assigns(:projects)).to eq projects
  end
end
