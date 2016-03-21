require 'spec_helper'

describe 'layouts/with_sidebar.html.erb' do
  it 'render sidebar' do
    render
    expect(rendered).to have_css('#sidebar')
    expect(rendered).to have_css('h3', :text => 'Current Projects')
  end
end
