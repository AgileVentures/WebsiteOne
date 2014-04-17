Given /^I have an avatar image at "([^"]*)"$/ do |link|
  @avatar_link = link
end

Given /^I am logged in as user with email "([^"]*)", with password "([^"]*)"$/ do |email, password|
  @user = FactoryGirl.create(:user, email: email, password: password, password_confirmation: password)
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

Given /user "([^"]*)" has joined on "([^"]*)"/ do |user_name, date|
  user = User.find_by_first_name(user_name)
  user.created_at = date.to_date
  user.save!
end

Given /^today is "([^"]*)"$/ do |date|
  Date.stub(today: date.to_date)
  #distance_of_time_in_words('01/01/2013'.to_date, Date.current)
end

Given(/^user with a bio$/) do
  step %{I exist as a user}
  @user.bio = "Lives on a farm with pigs and cows."
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
  @visitor = @visitor.merge(:password_confirmation => '')
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
  page.should have_content "Password confirmation doesn't match"
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

Then /^I should (not |)see my name$/ do |should|
  create_user
  # TODO Bryan: refactor to display_name
  if should == 'not '
    page.should_not have_content @user.display_name
  else
    page.should have_content @user.display_name
  end
end

Then /^I should (not |)see my gravatar$/ do |should|
  create_user
  # TODO Bryan: refactor to display_name
  if should == 'not '
    page.should_not have_css 'a[href="' + user_path(@user) + '"] img.projects-user-avatar'
  else
    page.should have_css 'a[href="' + user_path(@user) + '"] img.projects-user-avatar'
  end
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
  table.hashes.each do |attributes|
    create_test_user(attributes)
  end
end
When(/^I should see a list of all users$/) do
  #this is up to refactoring. Just a quick fix to get things rolling /Thomas
  page.should have_content 'All users'
end

When(/^I click pulldown link "([^"]*)"$/) do |text|
  page.find(:css, '.dropdown .dropdown-menu.dropdown-menu-right .fa-user').click
  click_link_or_button text
end

Given(/^I should be on the "([^"]*)" page for "(.*?)"$/) do |page, user|
  this_user = User.find_by_first_name(user) || User.find_by_email(user)
  expect(current_path).to eq path_to(page, this_user)
end

Given(/^I (?:am on|go to) my "([^"]*)" page$/) do |page|
  page.downcase!
  if page == 'profile'
    visit user_path(@user)
  elsif page == 'edit profile'
    visit edit_user_registration_path(@user)
  else
    pending
  end
end

Given /^I am on "(.*?)" page for user "(.*?)"$/ do |page, user_name|
  if user_name == 'me'
    user = @user
  else
    user = User.find_by_first_name(user_name)
  end

  case page
    when 'profile' then
      visit user_path(user)
    when page == 'edit profile'
      visit edit_user_registration_path(user)
  end
end

Then(/^I (should not|should)? see my email$/) do |option|
  if option == "should"
    page.should have_content @user.email
  else
    page.should_not have_content @user.email
  end
end

Then(/^(.*) in the preview$/) do |s|
  page.within(:css, 'div.preview_box') { step(s) }
end

Then(/^My email should be public$/) do
  user = User.find(@user.id)
  expect(user.display_email).to be_true
end

When(/^I set my ([^"]*) to be (public|private)?$/) do |value, option|
  value = value.underscore
  if option == 'public'
    check("user_display_#{value}")
  else
    #uncheck "Display #{value}"
    find("input#user_display_#{value}").set(false)
    find("input#user_display_#{value}").should_not be_checked
  end
end


When(/^I set ([^"]*) to be (true|false)?$/) do |value, option|
  value = value.underscore
  if option == 'true'
    check("user_#{value}")
  else
    uncheck "user_#{value}"
    find("input#user_#{value}").should_not be_checked
  end
end


Given(/^My ([^"]*) was set to (public|private)?/) do |value, option|
  @user.update_attributes("display_#{value.underscore}".to_sym => (option == 'public'))
end

# Bryan: To be deleted
#Then (/^I (should not|should)? see a link to my ([^"]*)$/) do |option, value|
#  pending
#end

Then(/^"([^"]*)" (should|should not) be checked$/) do |name, option|
  if option == 'should'
    page.find(:css, "input#user_#{name.underscore}").should be_checked
  else
    page.find(:css, "input#user_#{name.underscore}").should_not be_checked
  end
end

Given(/^user "(.*?)" follows projects:$/) do |user, table|
  @user = User.find_by_first_name user
  table.hashes.each do |project|
    step %Q{I should become a member of project "#{project[:title]}"}
  end
end

Given(/^I am logged in as "([^"]*)"$/) do |first_name|
  @user = User.find_by_first_name first_name
  visit new_user_session_path
  within ('#main') do
    fill_in 'user_email', :with => @user.email
    fill_in 'user_password', :with => test_user_password
    click_button 'Sign in'
  end
end

Then(/^(.*) in the members list$/) do |s|
  page.within(:css, '#all_members') do
    step s
  end
end

Given(/^I visit (.*)'s profile page$/) do |name|
  user = User.find_by_first_name name
  visit user_path user
end

Given(/^I add skills "(.*)"/) do |skills|
  skills.split(",").each { |s| page.execute_script "$('#skills').tags().addTag('#{s}')"}
end

Then(/^I should see skills "(.*)" on my profile/) do |skills|
  debugger
  page.all(:css, "#skills-show span").collect { |e| e.text }.sort.should == skills.split(",").sort
end

And(/^I have a GitHub profile with username "([^"]*)"$/) do |username|
  @github_profile_url = "https://github.com/#{username}"
end
When(/^my profile should be updated with my GH username$/) do
  @user.github_profile_url = @github_profile_url
  @user.save
  expect(@user.github_profile_url).to eq @github_profile_url
end

Then(/^the request should be to "(.*)"$/) do |url|
  expect(current_url).to eq url
end

Then(/^I should see the user's bio$/) do
  pending # express the regexp above with the code you wish you had
end


When(/^My email receivings is set to false$/) do
  @user.update_attribute(:receive_mailings, false)
end
