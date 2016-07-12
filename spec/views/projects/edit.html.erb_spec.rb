require 'spec_helper'

describe 'projects/edit.html.erb', type: :view do
  
  let(:project) { FactoryGirl.build_stubbed(:project)}
  
  before do
    assign(:project, project)
  end

  it 'renders project form labels' do
    render

    expect(rendered).to have_text('Title')
    expect(rendered).to have_text('Description')
    expect(rendered).to have_text('GitHub link')
    expect(rendered).to have_text('Issue Tracker link')
    expect(rendered).to have_text('Status')
  end

  it 'renders project form fields' do
    render

    expect(rendered).to have_field('Title')
    expect(rendered).to have_field('Description')
    expect(rendered).to have_field('GitHub link')
    expect(rendered).to have_field('Issue Tracker link')
    expect(rendered).to have_field('Status')
  end

  it 'renders Submit button' do
    render
    expect(rendered).to have_button('Submit')
  end

  it 'renders Back button' do
    render
    expect(rendered).to have_link('Back', :href => project_path(project))
  end

end
