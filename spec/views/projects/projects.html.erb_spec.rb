require 'spec_helper'

describe 'projects/projects.html.erb' do
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
      rendered.within('table#projects tbody') do |table_row|
        expect(table_row).to have_link('Show', href: projects_path)
      end
    end

    it 'should render a link Edit' do
      render
      rendered.within('table#projects tbody') do |table_row|
        #TODO Y replace with valid :id
        expect(table_row).to have_link('Edit', href: edit_project_path(1))
      end
    end

    it 'should render a link Destroy' do
      render
      rendered.within('table#projects tbody') do |table_row|
        #TODO Y replace with valid :id
        expect(table_row).to have_link('Destroy', href: destroy_project_path(1))
      end
    end

  end

end