require 'spec_helper'

describe 'layouts/application.html.erb' do
  context 'not signed in as registred user' do
    before :each do
      view.stub(:user_signed_in?).and_return(false)
    end

    it 'should include jQuery and bootstrap 3.0+ css & js files' do
      render
      rendered.should have_xpath("//link[contains(@href, '.css')]")
      rendered.should have_xpath("//script[contains(@src, '.js')]")
      #rendered.should have_xpath("//script[contains(@src, 'jquery')]")
    end

    it 'should render a navigation bar with links' do
      render
        rendered.should have_selector('div.navbar-wrapper')
        rendered.should have_link 'Check in', :href => new_user_session_path
        rendered.should have_link 'Sign up', :href => new_user_registration_path
    end
  end
  context 'user is signed in' do
    before :each do
      view.stub(:user_signed_in?).and_return(true)
    end
    it 'should render a navigation bar with links' do
      render
      rendered.should have_selector('div.navbar-wrapper')
      rendered.should_not have_link 'Check in'
      rendered.should_not have_link 'Sign up'
      rendered.should have_link 'My Account', :href => edit_user_registration_path
    end
  end
end

