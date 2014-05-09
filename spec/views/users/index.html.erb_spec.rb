require 'spec_helper'

describe "users/index.html.erb" do
  before :each do
    @users = [mock_model(User, :display_name => 'Bill Black', id: 1, :first_name => 'Bill', :last_name => 'Black', :email => 'bb123@somemail.com'),
              mock_model(User, :display_name => 'Charles Cyan', id: 2, :first_name => 'Charles', :last_name => 'Cyan', :email => 'cos@somemail.com'),
              mock_model(User, :display_name => 'Dave Devlish', id: 3, :first_name => 'Dave', :last_name => 'Devlish', :email => 'dave@me.com'),
              mock_model(User, :display_name => 'Eric Ectost', id: 4, :first_name => 'Eric', :last_name => 'Ectost', :email => 'eric@somemail.se')]
  end

  it 'should display a list of users' do
    render
    @users.each do |user|
      expect(rendered).to have_content(user.first_name)
    end
  end

  context 'when a user has no first or last name' do
    
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

  it 'renders avatar-link with href' do
    render
    expect(rendered).to have_xpath("//a[contains(@href, '/users/1')]")
    expect(rendered).to have_xpath("//a[contains(@href, '/users/2')]")
  end

  it 'renders User name link with href' do
    render
    expect(rendered).to have_xpath("//a[text()='Bill Black' and contains(@href, '/users/1')]")
    expect(rendered).to have_xpath("//a[text()='Charles Cyan' and contains(@href, '/users/2')]")
  end
end
