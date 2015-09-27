require 'spec_helper'

describe 'devise/sessions/new', :type => :view do

  before do
    expect(view).to receive(:resource).at_least(1).times.and_return(User.new)
    expect(view).to receive(:resource_name).at_least(1).times.and_return(:user)
    render
  end

  it 'renders the form to log in' do
    assert_select 'form[action=?][method=?]', user_session_path, 'post'  do
      expect(rendered).to have_css('input#user_email')
      expect(rendered).to have_css('input#user_password')
      expect(rendered).to have_css('input#user_remember_me')
      expect(rendered).to have_button('Sign in')
    end
  end

  it 'renders the social buttons' do
    expect(rendered).to have_css('.btn-github')
    expect(rendered).to have_link('GitHub', '/auth/github')
    expect(rendered).to have_css('.btn-gplus')
    expect(rendered).to have_link('Google+', '/auth/gplus')
  end

  it 'expects the social buttons to have an origin url param for redirect' do
    expect(rendered).to have_link('GitHub', '/auth/github?origin=')
    expect(rendered).to have_link('Google+', '/auth/gplus?origin=')
  end

  it 'renders the forgot password and sign up link' do
    expect(rendered).to have_link('Sign up', '/users/sign_up')
    expect(rendered).to have_link('Forgot your password?', '/users/password/new')
  end
end
