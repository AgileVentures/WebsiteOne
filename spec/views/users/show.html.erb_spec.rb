require 'spec_helper'

describe "users/show.html.erb" do
  before :each do
    now = DateTime.now
    thirty_days_ago = (now - 33)
    @projects = [
        mock_model(Project, friendly_id: 'title-1', title: 'Title 1'),
        mock_model(Project, friendly_id: 'title-2', title: 'Title 2'),
        mock_model(Project, friendly_id: 'title-3', title: 'Title 3')
    ]
    @user = FactoryGirl.build(:user,
                              first_name: 'Eric',
                              last_name: 'Els',
                              email: 'eric@somemail.se',
                              title_list: 'Philanthropist',
                              created_at: thirty_days_ago,
                              github_profile_url: 'http://github.com/Eric',
                              skill_list: [ 'Shooting', 'Hooting' ],
                              bio: 'Lonesome Cowboy')

    @user.stub(:projects_joined) { @projects }

    assign :user, @user
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
    @skills = ["rails", "ruby", "rspec"]
    assign :skills, @skills
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

  it 'should render the users gravatar image' do
    render
    expect(rendered).to have_css('img[src*=gravatar]')
  end

  it 'renders user first and last names' do
    render
    expect(rendered).to have_content(@user.first_name)
    expect(rendered).to have_content(@user.last_name)
  end

  describe 'geolocation' do
    it 'does not show globe icon when no country is set' do
      render
      expect(rendered).not_to have_selector "i[class='fa fa-globe fa-lg']"
    end

    it 'shows user country when known' do
      @user.country = 'Mozambique'
      render
      expect(rendered).to have_selector "i[class='fa fa-globe fa-lg']"
      expect(rendered).to have_content @user.country
    end

    it 'does not show clock icon when user timezone cannot be determined' do
      render
      expect(rendered).not_to have_selector "i[class='fa fa-clock-o fa-lg']"
    end

    it 'shows user timezone when it can be determined' do
      @user.latitude = 25.9500
      @user.longitude = 32.5833
      expect(NearestTimeZone).to receive(:to).with(@user.latitude, @user.longitude).and_return('Africa/Cairo')
      render
      expect(rendered).to have_selector "i[class='fa fa-clock-o fa-lg']"
      expect(rendered).to have_content 'Africa/Cairo'
    end
  end

  it 'should not display an edit button if it is not my profile' do
    @user_logged_in ||= FactoryGirl.create :user
    sign_in @user_logged_in

    render
    expect(rendered).not_to have_link('Edit', href: '/users/edit')
  end

  context 'profile privacy' do

    it 'should display email if it is set to public' do
      @user.display_email = true
      render
      expect(rendered).to have_link(@user.email)
    end

    it 'should display an hire me button if it set to public' do
      @user.display_hire_me = true
      render
      expect(rendered).to have_link('Hire me', href: user_path(@user))
    end

    it 'should not display email if it is set to private' do
      @user.display_email = false
      render
      expect(rendered).to_not have_link(@user.email)
    end

    it 'should display an hire me button if it set to private' do
      @user.display_hire_me = false
      render
      expect(rendered).not_to have_link('Hire me', href: user_path(@user))
    end
  end

  it 'should display Member for ..' do
    render
    expect(rendered).to have_text('Member for about 1 month')
  end

  it 'should render the users bio' do
    render
    expect(rendered).to have_text('Lonesome Cowboy')
  end

  it 'should render the users title' do
    render
    expect(rendered).to have_text('Philanthropist')
  end

  it 'displays GitHub profile if it is linked' do
    render
    expect(rendered).to have_link('Eric', href: 'http://github.com/Eric')
  end

  context 'users own profile page' do
    before(:each) do
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

  it 'renders list of user skills' do
    render
    @user.skill_list.each do |skill|
      expect(rendered).to have_text(skill)
    end
  end
end
