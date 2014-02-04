require 'spec_helper'

describe "users/show.html.erb" do
	before :each do
	  @user = mock_model(User, id: 4, :first_name => 'Eric', :last_name => 'Els', :email => 'eric@somemail.se')
		assign :user, @user
	end

  it 'renders big user avatar' do
    #view.stub(:gravatar_for).and_return('img_link')
    expect(view).to receive(:gravatar_for).with(@user.email ,size: 330).and_return('img_link')
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


  it 'renders list of followed projects'
  it 'renders user statistics'
  it 'renders list of PP sessions'
  it 'renders the embedded YT most recent PP'
end
