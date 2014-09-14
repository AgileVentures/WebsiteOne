require 'spec_helper'

describe 'dashboard/index.html.erb', type: :view do
  before :each do
    assign(:stats, {articles:{count:10},
                    projects:{count:5},
                    members:{count:100},
                    documents:{count:40}})
    @stats = :stats
  end

  it 'displays a tab view' do
    render
    expect(rendered).to have_css('ul#tabs')

  end

  it 'displays statistics correctly' do
    render
    expect(rendered).to have_content('10 Articles Published')
    expect(rendered).to have_content('5 Active Projects')
    expect(rendered).to have_content('100 AgileVentures Members')
    expect(rendered).to have_content('40 Documents Created')
  end
end
