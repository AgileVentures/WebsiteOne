require 'spec_helper'

describe 'devise/passwords/new', type: :view do
  before do
    expect(view).to receive(:resource).at_least(1).times.and_return(User.new)
    expect(view).to receive(:resource_name).at_least(1).times.and_return(:user)
    render
  end

  it 'renders the form to register' do
    assert_select 'form[action=?][method=?]', user_password_path, 'post'  do
      expect(rendered).to have_css('input#user_email')
      expect(rendered).to have_button('Send me reset password instructions')
    end
  end
end
