require 'spec_helper'

describe 'projects/show.html.erb' do
  before :each do
    @user = mock_model(User, id: 1, friendly_id: 'my-friend', first_name: 'John', last_name: 'Simpson', email: 'john@simpson.org')
    @project = mock_model(Project, :id => 1, friendly_id: 'my-friend-project', :title => "Title 1", :description => "Description 1", :status => "Active", :followers_count => 1, :user_id => @user.id, :created_at => Time.now, :documents => [])
    @created_by = ['by:', ([@user.first_name, @user.last_name].join(' '))].join(' ')
    assign(:project, @project)
    assign(:user, @user)
    view.stub(:project_created_by).and_return(@created_by)

  end

  it 'renders project description' do
    render
    expect(rendered).to have_text('Title 1')
    expect(rendered).to have_text('Description 1')
    expect(rendered).to have_text('Active')
    expect(rendered).to have_text('John Simpson')

  end

  it 'renders a followers count' do
    follow_count = @project.followers_count
    render
    expect(rendered).to have_text("This project has #{follow_count} members")
  end

  context 'user is signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
      view.stub(:current_user).and_return(@user)
    end

    context 'user is a member of project' do
      it 'should render join project button' do
        @user.should_receive(:following?).and_return(true)
        render
        rendered.should have_link('Leave project', unfollow_project_path(@project))
      end
    end
    context 'user is not a member of project' do
      it 'should render leave project button' do
        @user.should_receive(:following?).and_return(false)
        render
        rendered.should have_link('Join this project', follow_project_path(@project))
      end
    end
  end
end
