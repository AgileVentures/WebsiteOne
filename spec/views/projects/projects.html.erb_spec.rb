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
  end

end