require 'spec_helper'

describe "users/show.html.erb" do
	before :each do
    now = DateTime.now
    thirty_days_ago = (now - 30)
    @projects = [
        mock_model(Project, friendly_id: 'title-1', title: 'Title 1'),
        mock_model(Project, friendly_id: 'title-2', title: 'Title 2'),
        mock_model(Project, friendly_id: 'title-3', title: 'Title 3')
    ]
	  @user = mock_model(User, id: 4,
                             display_name: 'Eric Els',
                             first_name: 'Eric',
                             last_name: 'Els',
                             email: 'eric@somemail.se',
                             created_at: thirty_days_ago
                      )
		assign :user, @user
    assign :users_projects, @projects
    @youtube_videos = [
        {
            url: "http://www.youtube.com/100",
            title: "Random",
            published: '01/02/2015'.to_date
        },
        {
            url: "http://www.youtube.com/340",
            title: "Stuff",
            published: '01/03/2015'.to_date
        },
        {
            url: "http://www.youtube.com/2340",
            title: "Here's something",
            published: '01/04/2015'.to_date
        }
    ]
    assign :youtube_videos, @youtube_videos
	end

  it 'renders a table wih video links if there are videos' do
    render
    expect(render).to have_text('Title', 'Published')
  end

  it 'renders an embedded player' do
    expect(render).to have_selector('iframe#ytplayer')
  end

  it 'renders list of youtube links and published dates if user has videos' do
    render
    @youtube_videos.each do |video|
      expect(rendered).to have_link(video[:title], :href => video[:url])
      expect(rendered).to have_text(video[:published])
    end
  end
  it 'renders "no available videos" if user has no videos' do
    assign(:youtube_videos, nil)
    render
    expect(rendered).to have_text('Eric Els has no publicly viewable Youtube videos.')
  end

  it 'renders "connect youtube channel" when user views his profile and it is not yet connected' do
    @user.stub(youtube_id: nil)
    assign(:youtube_videos, nil)
    view.stub(current_user: @user)

    render
    expect(rendered).to have_link('Sync with YouTube')
  end

  it 'renders "disconnect youtube channel" when user views his profile and is connected' do
    @user.stub(youtube_id: 'test')
    assign(:youtube_videos, nil)
    view.stub(current_user: @user)

    render
    expect(rendered).to have_link('Disconnect YouTube')
  end

  it 'does not render "connect youtube channel" when user views other profile' do
    @user.stub(youtube_id: nil)
    assign(:youtube_videos, nil)
    view.stub(current_user: mock_model(User, id: 'test'))

    render
    expect(rendered).not_to have_text('Link your YouTube channel')
  end

  it 'renders big user avatar' do
    expect(view).to receive(:gravatar_for).with(@user.email ,size: 275).and_return('img_link')
    render
    expect(rendered).to have_css('img')
    expect(rendered).to have_xpath("//img[contains(@src, 'img_link')]")
  end
  it 'renders user first and last names' do
  	render
  	expect(rendered).to have_content(@user.first_name)
  	expect(rendered).to have_content(@user.last_name)
  end

  it 'show link to GitHub profile' do
  	pending("requires github API integration")
  end

  it 'should not display an edit button if it is not my profile' do
    @user_logged_in ||= FactoryGirl.create :user
    sign_in @user_logged_in

    render
    expect(rendered).not_to have_link('Edit', href: '/users/edit')
  end

  it 'should display Member for ..' do
    #Date.stub(today:'07/02/2014'.to_date )
    render
    expect(rendered).to have_text('Member for: about 1 month')
  end

  context 'users own profile page' do
    before :each do
        @user_logged_in ||= FactoryGirl.create :user
        sign_in @user_logged_in # method from devise:TestHelpers
    end
    it 'displays an edit button if it is my profile' do
      render
      expect(rendered).to_not have_xpath("//a[contains(@type, 'button')]")
    end


  end

  it 'renders list of followed projects' do
    render
    @projects.each do |project|
      expect(rendered).to have_link(project.title, href: project_path(project))
    end
  end

  it 'renders user statistics'
end
