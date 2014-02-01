Given /^I have an avatar image at "([^"]*)"$/ do |link|
  @avatar_link = link
end

Given /^I am logged in as user with email "([^"]*)", with password "([^"]*)"$/ do |email, password|
  @user = FactoryGirl.create(:user, email: email, password: password, password_confirmation: password )
  visit new_user_session_path
  within ('#main') do
    fill_in 'user_email', :with => email
    fill_in 'user_password', :with => password
    click_button 'Sign in'
  end
end

Given /^I am not logged in$/ do
  step 'I sign out'
end

Given /^I am logged in$/ do
  create_user
  sign_in
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I exist as an unconfirmed user$/ do
  create_unconfirmed_user
end

### WHEN ###
When(/^I submit "([^"]*)" as username$/) do |email|
  fill_in('user_email', :with => email)
end

When(/^I submit "([^"]*)" as password$/) do |password|
  fill_in('user_password', :with => password)
  fill_in('user_password_confirmation', :with => password)
end

When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end

When /^I sign out$/ do
  page.driver.submit :delete, destroy_user_session_path, {}
end

When /^I sign up with valid user data$/ do
  create_visitor
  sign_up
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  sign_up
end

When /^I sign up without a password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "")
  sign_up
end

When /^I sign up without a password$/ do
  create_visitor
  @visitor = @visitor.merge(:password => "")
  sign_up
end

When /^I sign up with a mismatched password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "changeme123")
  sign_up
end

When /^I return to the site$/ do
  visit root_path
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

When /^I edit my account details$/ do
  visit '/users/edit'
  #click_link "Edit account"
  within ('section#devise') do
    fill_in "user_first_name", :with => "newname"
    fill_in "user_last_name", :with => "Lastname"
    fill_in "user_organization", :with => "Company"
    #fill_in "user_current_password", :with => @visitor[:password]
    click_button "Update"
  end

end

When /^I look at the list of users$/ do
  visit '/'
end

### THEN ###
Then /^I should be signed in$/ do
  find_user.should == @user
  page.should have_content "Log out"
  page.should_not have_content "Sign up"
  page.should_not have_content "Log in"
end

Then /^I should be signed out$/ do
  page.should have_content "Sign up"
  page.should have_content "Log in"
  page.should_not have_content "Log out"
end

Then /^I see an unconfirmed account message$/ do
  page.should have_content "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I should see a successful sign up message$/ do
  page.should have_content "Welcome! You have signed up successfully."
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Email is invalid"
end

Then /^I should see a missing password message$/ do
  page.should have_content "Password can't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  page.should have_content "Password confirmation doesn't match"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Password confirmation doesn't match "
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully."
end

Then /^I should see my name$/ do
  create_user
  #page.should have_content @user[:first_name]
  page.should have_content([@user.first_name, @user.last_name].join(' '))
end

Given /^the sign in form is visible$/ do
  expect(page).to have_field('user_email')
  expect(page).to have_field('user_password')
  expect(page).to have_button('signin')
end

Then /^my account should be deleted$/ do
  expect(User.find_by_id(@user)).to be_false
end

Given(/^The database is clean$/) do
  DatabaseCleaner.clean
end

Given /^the following users exist$/ do |table|
  table.hashes.each do |hash|
    @users = User.create(hash)
    @users.save
  end
end
When(/^I should see a list of all users$/) do
  #this is up to refactoring. Just a quick fix to get things rolling /Thomas
  page.should have_content 'All users'
end

When(/^I click pulldown link "([^"]*)"$/) do |text|
  page.find("#user_info").click
  click_link_or_button text
end