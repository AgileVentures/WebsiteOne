require 'spec_helper'

describe "users/index.html.erb", :type => :view do
  before(:each) do
    @users = FactoryGirl.build_list(:user, 4)
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
      expect(rendered).to have_xpath("//a[contains(@href, '/users/#{user.slug}')]")
    end
  end
  context 'renders the users count in the sentence above' do
    it 'has valid users count' do
      render
      expect(rendered).to have_content("Check out our #{@users.count} awesome volunteers from all over the globe!")
    end

    it 'shows different sentence if invalid users count' do
      @users = []
      render
      expect(rendered).to have_content('It is a lonely planet we live in')
    end
  end
end
