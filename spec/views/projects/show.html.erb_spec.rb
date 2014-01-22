require 'spec_helper'

describe 'projects/show.html.erb' do
  before :each do
    Project.create(id: 1, title: "Title 1", description: "Description 1", status: "Active")

    assign(:project, Project.first)
  end

  it 'renders project table labels' do
    render
    expect(rendered).to have_text('Title 1')
    expect(rendered).to have_text('Description 1')
    expect(rendered).to have_text('Active')
  end

  it 'renders Back button' do
    render
    rendered.should have_link('Back', :href => projects_path)
  end

end
