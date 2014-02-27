require 'spec_helper'

describe 'projects/index.html.erb' do
  before :each do
    @user = stub_model(User, display_name: 'John Butcher')
    @projects_collection = (1..9).map { |id|
      stub_model(Project, {
          id: id,
          title: 'hello',
          description: 'world',
          status: 'one',
          friendly_id: "project-#{id}",
          created_at: '2014-01-23 23:39:15',
          user: @user
      }) }

    @projects_collection.stub(:total_pages).and_return(2)
    @projects_collection.stub(:current_page).and_return(1)
    assign(:projects, @projects_collection)
  end

  let(:projects_collection) { @projects_collection }

  context 'pagination' do
    it 'should render previous, next, and page numbers' do
      render
      rendered.should have_content '← Previous 1 2 Next →'
    end
  end

  context 'for signed in and not signed in users' do
    it 'should display a list of projects' do
      render
      rendered.should have_css('h1', :text => 'List of Projects')
      rendered.should have_css 'ul#project-list'
    end

    # Bryan: removed tests for table

    it 'should render a link' do
      render
      project = projects_collection.first
      rendered.within('ul#project-list') do |list|
        expect(list).to have_css %Q{a[href="#{project_path(projects_collection[0])}"]}, visible: true
      end
    end

  end

  context 'user signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end

    it 'should render a create new project button' do
      render
      rendered.should have_css %Q{a[href="#{new_project_path}"]}, visible: true
    end

    # Bryan: removed edit button from index page, step no longer required
  end

  context 'user not signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(false)
    end

    it 'should not render a create new project button' do
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
        expect(rendered_date.text).to contain(correct_date)
      end
    end
  end
end
