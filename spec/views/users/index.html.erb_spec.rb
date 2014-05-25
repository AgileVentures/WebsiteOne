require 'spec_helper'

describe "users/index.html.erb" do
  before(:each) do
    @users = []
    4.times { @users << FactoryGirl.build(:user) }
  end

  it 'should display a list of users' do
    render
    @users.each do |user|
      expect(rendered).to have_content(user.first_name)
    end
  end

  it 'renders User name link with href' do
    render
    @users.each do |user|
      expect(rendered).to have_xpath("//a[text()='#{user.first_name} #{user.last_name}' and contains(@href, '/users/#{user.slug}')]")
    end
  end
end
