require 'spec_helper'

describe 'projects/projects.html.erb' do
  before :each do
    Project.create(id: 1, title: "Title 1", description: "Description 1", status: "Status 1")
    Project.create(id: 2, title: "Title 2", description: "Description 2", status: "Status 2")
    Project.create(id: 3, title: "Title 3", description: "Description 3", status: "Status 3")
    assign(:projects, Project.all)
  end
  
  it 'should display table with columns' do
    render
    rendered.should have_css('table#projects')
    rendered.within('table#projects thead') do |t|
      t.should have_css('legend', :text => 'List of Projects')
      t.should have_css('th', :text => 'Title')
      t.should have_css('th', :text => 'Description')
      t.should have_css('th', :text => 'Status')
    end
  end

  context 'user signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end
    
    it 'should render a create new project button' do
      render
      rendered.should have_link('New Project', :href => new_project_path)
    end

    it 'should render a link Show' do
      render
      i = 0
      rendered.within('table#projects tbody') do |table_row|
        i += 1
        expect(table_row).to have_link('Show', href: project_path(i))
      end
    end

    it 'should render a link Edit' do
      render
      i = 0
      rendered.within('table#projects tbody') do |table_row|
        i += 1
        expect(table_row).to have_link('Edit', href: edit_project_path(i))
      end
    end

    it 'should render a link Destroy' do
      render
      i = 0
      rendered.within('table#projects tbody') do |table_row|
        i += 1
        expect(table_row).to have_link('Destroy', href: project_path(i))
      end
    end

  end

end
