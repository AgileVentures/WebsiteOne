require 'spec_helper'

describe 'layouts/with_sidebar.html.erb' do
  it 'render sidebar' do
    render
    rendered.should have_css('nav#sidebar')
    rendered.should have_css('h3', :text => 'Current Projects')
  end
end
