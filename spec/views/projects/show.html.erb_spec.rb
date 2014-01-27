require 'spec_helper'

describe 'projects/show.html.erb' do
  before :each do
    @project = Project.create(id: 1, title: "Title 1", description: "Description 1", status: "Active")
    assign(:project, Project.first)
    @user =  FactoryGirl.create(:user)
    assign(:user, User.first)

  end

  it 'renders project description' do
    render
    expect(rendered).to have_text('Title 1')
    expect(rendered).to have_text('Description 1')
    expect(rendered).to have_text('Active')
  end

  it 'renders a followers count' do
    follow_count = @project.followers_count
    render
    expect(rendered).to have_text("This project has #{follow_count} members")
  end

  it 'renders Back button' do
    render
    rendered.should have_link('Back', :href => projects_path)
  end
  context 'user is signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end

    context 'user is a member of project' do
      it 'should render join project button' do
        @user.follow(@project)
        render
        rendered.should have_link('Leave project', unfollow_project_path(@project))
      end
    end
    context 'user is not a member of project' do
      it 'should render leave project button' do
        @user.stop_following(@project)
        render
        rendered.should have_link('Join this project', follow_project_path(@project))
      end
    end
  end
end
