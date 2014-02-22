require 'spec_helper'

describe 'layouts/articles_layout' do
  it 'should render a sidebar' do
    render
    rendered.should have_selector('aside#sidebar')
    rendered.within('aside#sidebar') do |sidebar|
      sidebar.should have_text('Articles by tags')
      sidebar.should have_text('Ruby')
      sidebar.should have_text('Rails')
      sidebar.should have_text('Javascript')
      sidebar.should have_text('jQuery')
    end
  end
end

