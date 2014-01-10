require 'spec_helper'

describe 'projects/projects.html.erb' do
  it 'should display table with columns' do
    render
    rendered.should have_css('table#projects')
    rendered.within('table#projects thead') do |t|
      t.should have_css('legend', :text => 'List of projects')
      t.should have_css('th', :text => 'Title')
      t.should have_css('th', :text => 'Description')
      t.should have_css('th', :text => 'Status')
    end
  end

end