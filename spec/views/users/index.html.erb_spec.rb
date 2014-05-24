require 'spec_helper'

describe "users/index.html.erb" do
  before(:each) do
    @users = [
      FactoryGirl.build(:user, first_name: 'Bill', last_name: 'Black', email: 'bb123@somemail.com'),
      FactoryGirl.build(:user, first_name: 'Charles', last_name: 'Cyan', email: 'cos@somemail.com'),
      FactoryGirl.build(:user, first_name: 'Dave', last_name: 'Devlish', email: 'dave@me.com'),
      FactoryGirl.build(:user, first_name: 'Eric', last_name: 'Ectost', email: 'eric@somemail.se')
    ]
  end

  it 'should display a list of users' do
    render
    @users.each do |user|
      expect(rendered).to have_content(user.first_name)
    end
  end

  it 'renders User name link with href' do
    render
    expect(rendered).to have_xpath("//a[text()='Bill Black' and contains(@href, '/users/bill-black')]")
  end
end
