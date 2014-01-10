require 'spec_helper'

describe 'layouts/application.html.erb' do
  it 'should include jQuery and bootstrap 3.0+ css & js files' do
    render
    rendered.should have_xpath("//link[contains(@href, '.css')]")
    rendered.should have_xpath("//script[contains(@src, '.js')]")
    #rendered.should have_xpath("//script[contains(@src, 'jquery')]")
  end

  it 'should render a navbar' do
    render
    rendered.should have_selector('div.navbar-wrapper')
  end

  it 'should render links to site features' do
    render
    #TODO Y replace href with project_path helper
    rendered.should have_link 'Our projects', :href => 'projects'
  end

  context 'not signed in as registered user' do
    before :each do
      view.stub(:user_signed_in?).and_return(false)
    end
    it 'should render a navigation bar with links' do
      render
      # https://github.com/jnicklas/capybara/issues/384#issuecomment-1667712
      Capybara.string(rendered).find('section#header').tap do |header|
        header.should have_link 'Check in', :href => new_user_session_path
        header.should have_link 'Sign up', :href => new_user_registration_path
      end
    end
  end

  context 'user is signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end
    it 'should render a navigation bar with links' do
      render
      rendered.should_not have_link 'Check in', :href => new_user_session_path
      rendered.should_not have_link 'Sign up', :href => new_user_registration_path
      rendered.should have_link 'My Account', :href => edit_user_registration_path
    end
  end
end

