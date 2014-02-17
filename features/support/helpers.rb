module Helpers
  def create_visitor
    #@visitor =FactoryGirl(:user)
    @visitor ||= { :email => 'example@example.com',
                   :password => 'changemesomeday',
                   :password_confirmation => 'changemesomeday',
                   :slug => 'slug-ma'}
  end

  def find_user
    @user ||= User.where(:email => @visitor[:email]).first
  end

  def create_unconfirmed_user
    create_visitor
    delete_user
    sign_up
    visit destroy_user_session_path
  end

  def create_user
    create_visitor
    delete_user
    @user = FactoryGirl.create(:user, @visitor)
    @current_user = @user
  end

  def delete_user
    @user ||= User.where(:email => @visitor[:email]).first
    @user.destroy unless @user.nil?
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
    find_user
  end

  def sign_in
    visit new_user_session_path
    within ('#main') do
      fill_in 'user_email', :with => @visitor[:email]
      fill_in 'user_password', :with => @visitor[:password]
      click_button 'Sign in'
    end
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

World(ApplicationHelper)
World(Helpers)
World(WithinHelpers)
World(ActionView::Helpers)
