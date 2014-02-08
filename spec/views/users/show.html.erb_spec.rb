require 'spec_helper'

describe "users/show.html.erb" do
	before :each do
	  @user = mock_model(User, id: 4,
                             first_name: 'Eric',
                             last_name: 'Els',
                             email: 'eric@somemail.se',
                             created_at: Date.new(2014, 1, 1)
                      )
		assign :user, @user
	end

  it 'renders big user avatar' do
    #view.stub(:gravatar_for).and_return('img_link')
    expect(view).to receive(:gravatar_for).with(@user.email ,size: 275).and_return('img_link')
    render
    expect(rendered).to have_css('img')
    expect(rendered).to have_xpath("//img[contains(@src, 'img_link')]")
  end
  it 'renders user first and last names' do
  	render
  	expect(rendered).to have_content(@user.first_name)
  	expect(rendered).to have_content(@user.last_name)
  end

  it 'show link to GitHub profile' do
  	pending("requires github API integration")
  end

  it 'should not display an edit button if it is not my profile' do
    @user_logged_in ||= FactoryGirl.create :user
    sign_in @user_logged_in

    render
    expect(rendered).not_to have_link('Edit', href: '/users/edit')
  end

  it 'should display Joined on ..' do
    Date.stub(today:'07/02/2014'.to_date)
    render
    expect(rendered).to have_text('Member for: about 1 month')
  end

  context 'users own profile page' do
    before :each do
      #logged in as Eric
      #def signed_in_as_a_valid_user
        @user_logged_in ||= FactoryGirl.create :user
        sign_in @user_logged_in # method from devise:TestHelpers
      #end
    end
    it 'displays an edit button if it is my profile' do
      render
      expect(rendered).to_not have_xpath("//a[contains(@type, 'button')]")
    end


  end

  it 'renders list of followed projects'
  it 'renders user statistics'
  it 'renders list of PP sessions'
  it 'renders the embedded YT most recent PP'
end
