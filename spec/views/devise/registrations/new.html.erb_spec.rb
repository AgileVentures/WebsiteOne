require 'spec_helper'

describe 'devise/registrations/new' do

  before do
    view.should_receive(:resource).at_least(1).times.and_return(User.new)
    view.should_receive(:resource_name).at_least(1).times.and_return('user')
  end

  it 'renders the form to register' do
    render
    assert_select 'form[action=?][method=?]', user_registration_path, 'post'  do
      rendered.should have_css('input#user_email')
      rendered.should have_css('input#user_password')
      rendered.should have_css('input#user_password_confirmation')
      rendered.should have_button('Sign up')
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