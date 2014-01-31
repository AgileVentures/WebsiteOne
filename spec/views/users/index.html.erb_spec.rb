require 'spec_helper'

describe "users/index.html.erb" do
  before :each do
  	@users = [mock_model(User, :first_name => 'Bill', :last_name => 'Black', :email => 'bb123@somemail.com'),
  		mock_model(User, :first_name => 'Charles', :last_name => 'Cyan', :email => 'cos@somemail.com'),
  		mock_model(User, :first_name => 'Dave', :last_name => 'Devlish', :email => 'dave@me.com'),
  		mock_model(User, :first_name => 'Eric', :last_name => 'Ectost', :email => 'eric@somemail.se')]
  end

  it 'should display a list of users' do
  	render
  	@users.each do | user |
	  	expect(rendered).to have_content(user.first_name)
	  end
  end

  context 'when a user has no first or last name' do
  	it 'should display that users email address name' do
  		@users.first.stub(:first_name).and_return(nil)
  		@users.first.stub(:last_name).and_return(nil)
  		render

  		expect(rendered).to have_content(@users.first.email.split('@').first)
  	end

  	it 'should display only the last name' do
  		@users.first.stub(:first_name).and_return(nil)
  		render

  		expect(rendered).to have_content(@users.first.last_name)
  	end

  	it 'should display only the first name' do
  		@users.first.stub(:last_name).and_return(nil)
  		render

  		expect(rendered).to have_content(@users.first.first_name)
  	end
  end
end
