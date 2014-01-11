module Helpers
  def create_visitor
    #@visitor =FactoryGirl(:user)
    @visitor ||= { :email => "example@example.com",
                   :password => "changeme",
                   :password_confirmation => "changeme" }
  end


  def find_user
    @user ||= User.where(:email => @visitor[:email]).first
  end

  def create_unconfirmed_user
    create_visitor
    delete_user
    sign_up
    visit '/users/sign_out'
  end

  def create_user
    create_visitor
    delete_user
    @user = FactoryGirl.create(:user, @visitor)
  end

  def delete_user
    @user ||= User.where(:email => @visitor[:email]).first
    @user.destroy unless @user.nil?
  end

  def sign_up
    delete_user
    visit '/users/sign_up'
    within ('#wrap') do
      fill_in "user_email", :with => @visitor[:email]
      fill_in "user_password", :with => @visitor[:password]
      fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
      click_button "Sign up"
      find_user
    end
  end

  def sign_in
    visit new_user_session_path
    fill_in 'user_email', :with => @visitor[:email]
    fill_in 'user_password', :with => @visitor[:password]
    click_button 'Sign in'
  end
end

World(Helpers)