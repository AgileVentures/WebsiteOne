require 'spec_helper'

describe 'devise/registrations/new', :type => :view do

  before do
    expect(view).to receive(:resource).at_least(1).times.and_return(User.new)
    expect(view).to receive(:resource_name).at_least(1).times.and_return(:user)
    render
  end

  it 'renders the form to register' do
    assert_select 'form[action=?][method=?]', user_registration_path, 'post'  do
      expect(rendered).to have_css('input#user_email')
      expect(rendered).to have_css('input#user_password')
      expect(rendered).to have_css('input#user_password_confirmation')
      expect(rendered).to have_button('Sign up')
    end
  end

  it 'renders the social buttons' do
    expect(rendered).to have_css('.btn-github')
    expect(rendered).to have_link('GitHub', '/auth/github')
    #expect(rendered).to have_css('.btn-gplus') disabled during g+ failures
    #expect(rendered).to have_link('Google+', '/auth/gplus')
  end

  it 'renders the forgot password and sign in link' do
    expect(rendered).to have_link('Sign in', '/users/sign_in')
    expect(rendered).to have_link('Forgot your password?', '/users/password/new')
  end
end
