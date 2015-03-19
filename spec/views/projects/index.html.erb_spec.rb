require 'spec_helper'

describe 'projects/index.html.erb', type: :view do
  
  let(:user) { FactoryGirl.build_stubbed(:user) }
  let(:projects_collection) { FactoryGirl.create_list(:project, 9, user: user) }

  before do
    allow(projects_collection).to receive(:total_pages).and_return(2)
    allow(projects_collection).to receive(:current_page).and_return(1)

    assign(:projects, projects_collection)
    assign(:user, user)
  end

  context 'pagination' do
    it 'renders previous, next, and page numbers' do
      render
      expect(rendered).to have_content '← Previous 1 2 Next →'
    end
  end

  context 'for signed in and not signed in users' do
    it 'displays a list of projects' do
      render
      expect(rendered).to have_css('h1', :text => 'List of Projects')
      expect(rendered).to have_css 'ul#project-list'
    end

    # Bryan: removed tests for table

    it 'renders a link' do
      render
      rendered.within('ul#project-list') do |list|
        expect(list).to have_css %Q{a[href="#{project_path(projects_collection.first)}"]}, visible: true
      end
    end

    it 'renders the commit count for projects that have a commit count' do
      allow(projects_collection.first).to receive(:commit_count).and_return(1000)
      render
      rendered.within('ul#project-list') do |list|
        expect(list).to have_css('li[title="1000 commits"]')
      end
    end
  end

  context 'user signed in' do
    before do
      allow(view).to receive(:user_signed_in?).and_return(true)
    end

    it 'renders a create new project button' do
      render
      expect(rendered).to have_css %Q{a[href="#{new_project_path}"]}, visible: true
    end

    # Bryan: removed edit button from index page, step no longer required
  end

  context 'user not signed in' do
    before do
      allow(view).to receive(:user_signed_in?).and_return(false)
    end

    it "doesn't render a create new project button" do
      render
      expect(rendered).not_to have_link('New Project', :href => new_project_path)
    end

    # Bryan: removed edit button from index page, tests no longer required
  end

  describe 'content formatting' do
    it 'renders format in short style' do
      render
      rendered.within('ul#project-list') do |rendered_date|
        correct_date = time_ago_in_words(projects_collection.sample(1).first.created_at)
        expect(rendered_date.text).to include(correct_date)
      end
    end
  end
end
