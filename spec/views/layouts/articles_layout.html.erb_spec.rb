require 'spec_helper'

describe 'layouts/articles_layout' do
  it 'should render a sidebar' do
    render
    expect(rendered).to have_selector('aside#sidebar')
    rendered.within('aside#sidebar') do |sidebar|
      expect(sidebar).to have_text('Articles by tags')
      expect(sidebar).to have_text('Ruby')
      expect(sidebar).to have_text('Rails')
      expect(sidebar).to have_text('Javascript')
      expect(sidebar).to have_text('jQuery')
    end
  end
end

