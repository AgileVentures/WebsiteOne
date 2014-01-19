require 'spec_helper'

describe 'devise/registrations/edit.html.erb' do
  before(:each)
  #stubbing out devise methods
  view.should_receive(:resource).at_least(1).times.and_return(User.new)
  view.should_receive(:resource_name).at_least(1).times.and_return('user')
  view.should_receive(:devise_mapping).and_return(Devise.mappings[:user])
end

it 'shows required labels' do

  render
  expect(rendered).to have_text('Title')
  end

it 'shows required user fields' do

  render
end

it 'shows avatar image' do

end

it 'shows Update button' do

end

it 'shows Cancel my account button' do
  rendered.should have_link('Back', :href => projects_path)
end

it 'shows Back button' do
  rendered.should have_button('Submit')
end





