require 'spec_helper'

describe 'projects/show.html.erb' do
  before :each do
    @user = mock_model(User, id: 1, friendly_id: 'my-friend', first_name: 'John', last_name: 'Simpson', email: 'john@simpson.org', display_name: 'John Simpson')
    @project = mock_model(Project, :id => 1, friendly_id: 'my-friend-project', :title => "Title 1", :description => "Description 1", :status => "Active", :user_id => @user.id, :created_at => Time.now, :documents => [])
    @created_by = ['by:', ([@user.first_name, @user.last_name].join(' '))].join(' ')
    assign :project, @project
    assign :user, @user
    assign :documents, [ ]
    assign :members, [ @user ]
    view.stub(:project_created_by).and_return(@created_by)
    @project.should_receive(:user).and_return(@user)

  end

  it 'renders project description' do
    render
    expect(rendered).to have_text @project.title
    expect(rendered).to have_text @project.description
    expect(rendered).to have_text @project.status.upcase
    expect(rendered).to have_text @user.display_name

  end

  it 'renders a followers count' do
    render
    expect(rendered).to have_text('Members (1)')
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
        rendered.should have_css %Q{a[href="#{unfollow_project_path(@project)}"]}, visible: true
      end
    end
    context 'user is not a member of project' do
      it 'should render leave project button' do
        @user.should_receive(:following?).and_return(false)
        render
        rendered.should have_css %Q{a[href="#{follow_project_path(@project)}"]}, visible: true
      end
    end
  end
end
