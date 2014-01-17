require 'spec_helper'
#TODO YA add specs for row id's. since cuc scenarios rely on them

describe 'projects/index.html.erb' do
  before :each do
    #TODO Y use factoryGirl
    Project.create(id: 1, title: "Title 1", description: "Description 1", status: "Status 1")
    Project.create(id: 2, title: "Title 2", description: "Description 2", status: "Status 2")
    Project.create(id: 3, title: "Title 3", description: "Description 3", status: "Status 3")

    assign(:projects, Project.all)
  end

  context 'for signed in and not signed in users' do
    it 'should display table with columns' do
      render

      rendered.should have_css('table#projects')

      rendered.within('table#projects thead') do |table_row|
        table_row.should have_css('legend', :text => 'List of Projects')
        table_row.should have_css('th', :text => 'Title')
        table_row.should have_css('th', :text => 'Description')
        table_row.should have_css('th', :text => 'Created')
        table_row.should have_css('th', :text => 'Status')
      end
    end
  end

  context 'user signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end

    it 'should render a create new project button' do
      render
      rendered.should have_link('New Project', :href => new_project_path)
    end

    it 'should render a link Show' do
      render
      #TODO Y refactor to a smarter traversing
      i = 0
      rendered.within('table#projects tbody') do |table_row|
        i += 1
        expect(table_row).to have_link('Show', href: project_path(i))
      end
    end

    it 'should render a link Edit' do
      render
      #TODO Y refactor to a smarter traversing
      i = 0
      rendered.within('table#projects tbody') do |table_row|
        i += 1
        expect(table_row).to have_link('Edit', href: edit_project_path(i))
      end
    end

    it 'should render a link Destroy' do
      render
      #TODO Y refactor to a smarter traversing
      i = 0
      rendered.within('table#projects tbody') do |table_row|
        i += 1
        expect(table_row).to have_link('Destroy', href: project_path(i))
      end
    end

  end

  context 'user not signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(false)
    end

    it 'should not render a create new project button' do
      render
      expect(rendered).not_to have_link('New Project', :href => new_project_path)
    end

    it 'should not render a link Show' do
      render
      #TODO Y refactor to a smarter traversing
      i = 0
      rendered.within('table#projects tbody') do |table_row|
        i += 1
        expect(table_row).not_to have_link('Show', href: project_path(i))
      end
    end

    it 'should not render a link Edit' do
      render
      #TODO Y refactor to a smarter traversing
      i = 0
      rendered.within('table#projects tbody') do |table_row|
        i += 1
        expect(table_row).not_to have_link('Edit', href: edit_project_path(i))
      end
    end

    it 'should not render a link Destroy' do
      render
      #TODO Y refactor to a smarter traversing
      i = 0
      rendered.within('table#projects tbody') do |table_row|
        i += 1
        expect(table_row).not_to have_link('Destroy', href: project_path(i))
      end
    end
  end

  describe 'content formatting' do
    it 'renders format in short style' do

      render
      # checking the date of project_id: 1 on row 1, column 4
      rendered.within('table tr#1 td[4]') do |rendered_date|
        correct_date = Project.find(1).created_at.strftime("%Y-%m-%d")
        expect(rendered_date.text).to eq(correct_date)
      end
    end

  end

end
