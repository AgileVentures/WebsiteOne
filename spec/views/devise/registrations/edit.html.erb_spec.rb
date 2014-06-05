require 'spec_helper'

describe 'devise/registrations/edit.html.erb' do
  before(:each) do
    #stubbing out devise methods
    @user = FactoryGirl.build(:user)
    @user.stub(:all_following).and_return([ stub_model(Project, title: 'Title 1'), stub_model(Project, title: 'Title 2') ])
    view.stub(:current_user).and_return(@user)
    view.stub(:resource).and_return(@user)
    view.stub(:resource_name).and_return('user')
    view.stub(:devise_mapping).and_return(Devise.mappings[:user])
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

  it 'renders "connect youtube channel" when user views his profile and it is not yet connected' do
    @user.stub(youtube_id: nil)
    assign(:youtube_videos, nil)
    view.stub(current_user: @user)

    render
    expect(rendered).to have_link('Sync with YouTube')
  end

  it 'renders "disconnect youtube channel" when user views his profile and is connected' do
    @user.stub(youtube_id: 'test')
    assign(:youtube_videos, nil)
    view.stub(current_user: @user)

    render
    expect(rendered).to have_link('Disconnect YouTube')
  end

  it 'does not render "connect youtube channel" when user views other profile' do
    @user.stub(youtube_id: nil)
    assign(:youtube_videos, nil)
    current = mock_model(User, id: 'test')
    current.stub(:all_following).and_return([])
    view.stub(current_user: current)

    render
    expect(rendered).not_to have_text('Link your YouTube channel')
  end

  it 'should NOT have data-no-turbolink attribute around the youtube button' do
    render

    rendered.should_not have_css '[data-no-turbolink] .fa-youtube'
  end


  #it "displays a preview button" do
  #  render
  #  expect(rendered).to have_link 'Preview'
  #end

  #it 'shows Back button' do
  #  render
  #  expect(rendered).to have_link('Back')
  #end

  #it '#devise_error_messages_flash shows error messages ' do
  #  user = User.new
  #  user.password = ''
  #  user.save
  #
  #  view.stub(:resource).and_return(user)
  #
  #  render
  #  expect(rendered).to have_text("Password can't be blank")
  #end


end



