module Helpers

  def default_test_author
    @default_test_author ||= User.find_by_email(default_test_user_details[:email])
    if @default_test_author.nil?
      @default_test_author = User.create!(default_test_user_details)
    end
    @default_test_author
  end

  def test_ip_address
    '127.0.0.1'
  end

  def test_user_password
    '12345678'
  end

  def default_test_user_details
    {
      first_name: 'Tester',
      last_name: 'Person',
      email: 'testuser@agileventures.org',
      last_sign_in_ip: test_ip_address,
      password: test_user_password,
      password_confirmation: test_user_password,
      display_profile: true,
      latitude: 59.33,
      longitude: 18.06,
      country: 'Stockholm'
    }
  end

  def create_visitor
    @visitor ||= { :first_name => 'Anders',
                   :last_name => 'Persson',
                   :email => 'example@example.com',
                   :password => 'changemesomeday',
                   :password_confirmation => 'changemesomeday',
                   :slug => 'slug-ma',
                   :country => 'Sweden'}
  end

  def create_test_user(options = {})
    skills = options.delete "skills"
    options = default_test_user_details.merge options
    user = User.new(options)
    user.skill_list = skills
    user.save!
  end

  def create_unconfirmed_user
    create_visitor
    delete_user
    sign_up
    visit destroy_user_session_path
  end

  def create_user
    @user ||= FactoryGirl.create(:user, create_visitor)
    @current_user = @user
  end

  def delete_user
    @user.destroy if @user
    @user = nil
    @current_user = nil
  end

  def sign_up
    delete_user
    visit new_user_registration_path
    within ('#main') do
      fill_in 'user_email', :with => @visitor[:email]
      fill_in 'user_password', :with => @visitor[:password]
      fill_in 'user_password_confirmation', :with => @visitor[:password_confirmation]
      click_button 'Sign up'
    end
  end

  def sign_in
    visit new_user_session_path
    within ('#main') do
      fill_in 'user_email', :with => @visitor[:email]
      fill_in 'user_password', :with => @visitor[:password]
      click_button 'Sign in'
    end
  end

  def all_users
    @all_users = User.all
  end


end

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end

  def has_link_or_button?(page, name)
    page.has_link?(name) || page.has_button?(name)
  end
end


module Capybara
  class Session
    def has_link_or_button?(name)
      has_link?(name) || has_button?(name)
    end
  end
end

class String
  def underscore
    self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("- ", "_").
      downcase
  end
end

module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end
World(ScrumsHelper)
World(ApplicationHelper)
World(Helpers)
World(WithinHelpers)
World(WaitForAjax)
World(ActionView::Helpers)
