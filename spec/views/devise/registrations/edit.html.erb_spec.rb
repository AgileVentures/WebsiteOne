require 'spec_helper'

describe 'devise/registrations/edit.html.erb' do
  before(:each) do
  #stubbing out devise methods
  view.should_receive(:resource).at_least(1).times.and_return(User.new)
  view.should_receive(:resource_name).at_least(1).times.and_return('user')
  view.should_receive(:devise_mapping).and_return(Devise.mappings[:user])
  end

it 'shows required labels' do
  render
  expect(rendered).to have_text('Edit your details:')
  expect(rendered).to have_text('Email')
  expect(rendered).to have_text('Password')
  expect(rendered).to have_text('Password confirmation')
  expect(rendered).to have_text('Current password')
  expect(rendered).to have_text('Cancel my account')
  expect(rendered).to have_text('Unhappy?')
  end

it 'shows required user fields' do
  render
  expect(rendered).to have_field('Email')
  expect(rendered).to have_field('Password')
  expect(rendered).to have_field('Password confirmation')
  expect(rendered).to have_field('Current password')
  end

it 'shows avatar image' do
  view.stub(:gravatar_for).and_return('img_link')
  render
  expect(rendered).to have_css('img')
  expect(rendered).to have_xpath("//img[contains(@src, 'img_link')]")
end



it 'shows Update button' do
  render
  expect(rendered).to have_button('Update')

end

it 'shows Cancel my account button' do
  render
  expect(rendered).to have_button('Cancel my account')
end

it 'shows Back button' do
  render
  expect(rendered).to have_link('Back')
end

end



