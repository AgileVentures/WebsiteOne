require 'spec_helper'

describe 'layouts/application.html.erb' do
  it 'should include css & js files' do
    render
    rendered.should have_xpath("//link[contains(@href, '.css')]")
    rendered.should have_xpath("//script[contains(@src, '.js')]")
  end

  it 'should render a navbar' do
    render
    rendered.should have_selector('div.navbar-wrapper')
  end

  it 'should render links to site features' do
    render
    #TODO Y replace href with project_path helper
    rendered.should have_link 'Our projects', :href => projects_path
  end

  it 'should render a footer' do
    render
    rendered.should have_selector('footer')
    rendered.should have_text ('AgileVentures - Crowdsourced Learning')
  end


  context 'not signed in as registered user' do
    before :each do
      view.stub(:user_signed_in?).and_return(false)
    end
    it 'should render a navigation bar with links' do
      render
      rendered.within('section#header') do |header|
        header.should have_link 'Check in', :href => new_user_session_path
        header.should have_link 'Sign up', :href => new_user_registration_path
      end
    end

    it 'should return 200 for all links' do
      render
      rendered.within('section#header') do |header|
        links = header.all('a').map { |el| el[:href] }
        links.each do |link|
            visit link
            debugger
            page.status_code.should == 200
        end
      end
    end
  end

  context 'user is signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end
    it 'should render a navigation bar with links' do
      render
      rendered.within('section#header') do |header|
        header.should_not have_link 'Check in', :href => new_user_session_path
        header.should_not have_link 'Sign up', :href => new_user_registration_path
        header.should have_link 'My Account', :href => edit_user_registration_path
      end
    end
  end
end

