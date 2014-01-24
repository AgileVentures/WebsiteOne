require 'spec_helper'

describe 'layouts/application.html.erb' do
  it 'should include css & js files' do
    render
    rendered.should have_xpath("//link[contains(@href, '.css')]")
    rendered.should have_xpath("//script[contains(@src, '.js')]")
  end

  it 'should not have div nested inside p' do
    should_not have_selector("p>div")
  end

  it 'should not have extra escaped html' do
    should_not =~ /&lt;/
    should_not =~ /&gt;/
    should_not =~ /&amp;/
  end

  it 'should render a navbar' do
    render
    rendered.should have_selector('div.navbar')
  end

  it 'should render links to site features' do
    render
    #TODO Y replace href with project_path helper
    rendered.should have_link 'Our projects', :href => projects_path
    rendered.should have_link 'About us', :href => pages_path('about_us')
  end

  it 'should render a footer' do
    render
    rendered.should have_selector('footer')
    rendered.should have_text ('AgileVentures - Crowdsourced Learning')
  end

  it 'should return 200 for all link visits' do
    render
    rendered.within('div.navbar') do |header|
      links = header.all('a').map { |el| el[:href] }
      links.each do |link|
        visit link
        page.status_code.should == 200
      end
    end
  end

  context 'not signed in as registered user' do
    before :each do
      view.stub(:user_signed_in?).and_return(false)
    end

    it 'should render login & sign-up links' do
      render
      rendered.within('div.navbar') do |header|
        header.should have_link 'Log in', :href => new_user_session_path
        header.should have_link 'Sign up', :href => new_user_registration_path
      end
    end
  end

  context 'user is signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end
    it 'should render navigation links' do
      render
      rendered.within('div.navbar') do |header|
        header.should_not have_link 'Log in', :href => new_user_session_path
        header.should_not have_link 'Sign up', :href => new_user_registration_path
        header.should have_link 'My Account', :href => edit_user_registration_path
      end
    end

    it 'should return 200 on link visit' do
      visit edit_user_registration_path
      page.status_code.should == 200
    end

  end
end

