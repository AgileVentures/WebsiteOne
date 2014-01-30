require 'spec_helper'

describe 'devise/sessions/new' do

  before do
    view.should_receive(:resource).at_least(1).times.and_return(User.new)
    view.should_receive(:resource_name).at_least(1).times.and_return('user')
  end

  it 'renders the form to log in' do
    render
    assert_select 'form[action=?][method=?]', user_session_path, 'post'  do
      rendered.should have_css('input#user_email')
      rendered.should have_css('input#user_password')
      rendered.should have_css('input#user_remember_me')
      rendered.should have_button('Sign in')
    end
  end

  it 'renders the social buttons' do
    render
    rendered.should have_css('.btn-github')
    rendered.should have_link('GitHub', '/auth/github')
    rendered.should have_css('.btn-gplus')
    rendered.should have_link('Google+', '/auth/gplus')
  end
end
