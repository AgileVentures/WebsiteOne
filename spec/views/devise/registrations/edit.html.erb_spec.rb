require 'spec_helper'

describe 'devise/registrations/edit.html.erb' do
  before(:each) do
    #stubbing out devise methods
    @user = FactoryGirl.build(:user)
    @user.stub(:all_following).and_return([ stub_model(Project, title: 'Title 1'), stub_model(Project, title: 'Title 2') ])
    allow(view).to receive(:current_user).and_return(@user)
    allow(view).to receive(:resource).and_return(@user)
    allow(view).to receive(:resource_name).and_return(:user)
    allow(view).to receive(:devise_mapping).and_return(Devise.mappings[:user])
  end

  it 'shows required labels' do
    render
    expect(rendered).to have_text('Account details')
    expect(rendered).to have_text('First name')
    expect(rendered).to have_text('Last name')
    expect(rendered).to have_text('Email')
  end

  it 'shows avatar image' do
    render
    expect(rendered).to have_css('img.thumbnail')
  end

  it 'shows required user fields' do
    render
    expect(rendered).to have_field('First name')
    expect(rendered).to have_field('Last name')
    expect(rendered).to have_field('Email')
    expect(rendered).to have_css('#skills')
    expect(rendered).to have_field('Bio')
  end

  it 'shows Update button' do
    render
    expect(rendered).to have_button('Update')

  end

  it 'shows Update button' do
    render
    expect(rendered).to have_button('Update')

  end

  it 'should render a checkbox for the public email option' do
    render
    expect(rendered).to have_css "input[type='checkbox']#user_display_email"
  end

  it 'should render a checkbox for the public profile option' do
    render
    expect(rendered).to have_css "input[type='checkbox']#user_display_profile"
    end

  it 'should render a checkbox for the public hire me button option' do
    render
    expect(rendered).to have_css "input[type='checkbox']#user_display_hire_me"
  end
end
