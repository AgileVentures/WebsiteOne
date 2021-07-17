Given /^I have an avatar image at "([^"]*)"$/ do |link|
  @avatar_link = link
end

Given(/^I am logged in as a user with "([^"]*)"$/) do |plan|
  StaticPage.create!(title: 'getting started', body: 'remote pair programming')
  email =  "Susan_#{plan.parameterize}@gmail.com"
  password = "Susan_#{plan}"
  @current_user = @user = FactoryBot.create(:user, :with_karma, first_name: "Susan_#{plan}", email: email,
                                                                password: password, password_confirmation: password)

  set_user_as_premium(@user, plan)

  visit new_user_session_path
  within('#main') do
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_button 'Sign in'
  end
end

Given /^I am logged in as( a premium)? user with (?:name "([^"]*)", )?email "([^"]*)", with password "([^"]*)"$/ do |premium, name, email, password|
  StaticPage.create!(title: 'getting started', body: 'remote pair programming')
  @current_user = @user = create(:user,
                                 :with_karma,
                                 first_name: name,
                                 email: email,
                                 password: password,
                                 password_confirmation: password)
  set_user_as_premium(@user) if premium

  visit new_user_session_path
  within('#main') do
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_button 'Sign in'
  end
end

Given /^A( premium)? user with (?:name "([^"]*)", )?email "([^"]*)", with password "([^"]*)" exists$/ do |premium, name, email, password|
  split_name = name.split
  first_name = split_name.first
  last_name  = split_name.last
  @current_user = @user = create(:user,
                                 :with_karma,
                                 first_name: first_name,
                                 last_name: last_name,
                                 email: email, password: password, password_confirmation: password)
  set_user_as_premium(@user) if premium
end

def set_user_as_premium(user, plan = 'Premium')
  return if plan.downcase == 'free'

  subscription = Subscription.create(
    user: user,
    plan: Plan.find_by(name: plan),
    started_at: Time.now
  )
  customer = Stripe::Customer.create(
    email: user.email,
    source: StripeMock.create_test_helper.generate_card_token
  )
  customer.subscriptions.create(plan: plan.downcase.delete(' '))
  payment_source = PaymentSource::Stripe.create(
    identifier: customer.id,
    subscription: subscription
  )
end

Given /^(?:|I am) logged in as a premium user paid for the plan via PayPal$/ do
  @current_user = create(:user)
  visit new_user_session_path
  within('#main') do
    fill_in 'user_email', with: @current_user.email
    fill_in 'user_password', with: @current_user.password
    click_button 'Sign in'
  end
  set_cookie "_WebsiteOne_session=#{page.driver.cookies['_WebsiteOne_session'].value}"
  get subscriptions_paypal_redirect_path payment_method: 'paypal',
                                         payer_id: 'paypal_payer_id',
                                         plan: 'premium',
                                         email: 'matt+buyer@agileventures.org'
end

Given /^(?:|I am) logged in as a CraftAcademy premium user$/ do
  @current_user = create(:user)
  subscription = Subscription.create(user: @current_user,
                                     plan: Plan.find_by(name: 'Premium'), started_at: Time.now)
  PaymentSource::CraftAcademy.create(
    subscription: subscription
  )
  visit new_user_session_path
  within('#main') do
    fill_in 'user_email', with: @current_user.email
    fill_in 'user_password', with: @current_user.password
    click_button 'Sign in'
  end
end

Given /^I am not logged in$/ do
  step 'I sign out'
end

Given /^I am logged in as a privileged user$/ do
  create_privileged_user
  login_as @user, scope: :user
end

Given(/^I am logged in$/) do
  create_user
  sign_in
end

Given /^I have logged in$/ do
  create_user
  login_as @user, scope: :user
end


Given /^I have logged in as a user who is authorized to view the AVDashboard$/ do
  create_user(can_see_dashboard: true)
  login_as @user, scope: :user
end

Given('I have logged in as {string}') do |first_name|
  @user = User.find_by_first_name first_name
  login_as @user, scope: :user
end

Given /^I have logged in as a user who is not authorized to view the AVDashboard$/ do
  create_user
  login_as @user, scope: :user
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I exist as a user who is not authorized to view the AVDashboard$/ do
  create_user
end

Given /^I exist as a user who is authorized to view the AVDashboard$/ do
  create_user(can_see_dashboard: true)
end

Given /^I exist as a user signed up via google/ do
  step 'I am on the "registration" page'
  step 'I click "Google"'
  @user = User.where(email: 'mock@email.com').first
end

When(/^I have deactivated my account$/) do
  @user.destroy
end

Given(/^User (.*)'s account is deleted$/) do |name|
  user = User.find_by_first_name name
  user.really_destroy!
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

### WHEN ###
When(/^I submit "([^"]*)" as username$/) do |email|
  fill_in('user_email', with: email)
end

When(/^I submit "([^"]*)" as password$/) do |password|
  fill_in('user_password', with: password)
  fill_in('user_password_confirmation', with: password)
end

When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end

When /^I sign out$/ do
  page.driver.submit :delete, destroy_user_session_path, {}
end

When(/^I sign off$/) do
  delete_user
end

When /^I sign up with valid user data( giving consent)?$/ do |consent|
  create_visitor(receive_mailings: !consent.nil?)
  sign_up
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(email: 'notanemail')
  sign_up
end

When /^I sign up without a password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(password_confirmation: '')
  sign_up
end

When /^I sign up without a password$/ do
  create_visitor
  @visitor = @visitor.merge(password: '')
  sign_up
end

When /^I sign up with a mismatched password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(password_confirmation: 'changeme123')
  sign_up
end

When /^I return to the site$/ do
  visit root_path
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(email: 'wrong@example.com')
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(password: 'wrongpass')
  sign_in
end

When /^I filter users for "(.*?)"$/ do |first_name|
  fill_in 'user-filter', with: first_name
  # click_link_or_button :UsersFilterSubmit
end

When /^I sign up with GitHub$/ do
  click_link_or_button 'GitHub'
end

### THEN ###
Then /^I should be signed in$/ do
  expect(page).to have_content 'Log out'
  expect(page).to_not have_content 'Log in'
end

And /^I should not see a sign up link$/ do
  expect(page).to have_no_link 'Sign up'
end

Then /^I should be signed out$/ do
  expect(page).to have_content 'Sign up'
  expect(page).to have_content 'Log in'
  expect(page).to_not have_content 'Log out'
end

Then /^I see a successful sign in message$/ do
  expect(page).to have_content 'Signed in successfully.'
end

Then /^I should see a successful sign up message$/ do
  expect(page).to have_content 'Welcome! You have signed up successfully.'
end

Then /^I should see an invalid email message$/ do
  expect(page).to have_content 'Email is invalid'
end

Then /^I should see a missing password message$/ do
  expect(page).to have_content "Password can't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  expect(page).to have_content "Password confirmation doesn't match"
end

Then /^I should see a mismatched password message$/ do
  expect(page).to have_content "Password confirmation doesn't match"
end

Then /^I should see a signed out message$/ do
  expect(page).to have_content 'Signed out successfully.'
end

Then /^I see an invalid login message$/ do
  expect(page).to have_content 'Invalid email or password.'
end

Then(/^I see a user deactivated message$/) do
  expect(page).to have_content 'User is deactivated.'
end

Then /^I should (not |)see my name$/ do |should|
  create_user
  # TODO: Bryan: refactor to display_name
  if should == 'not '
    expect(page).to_not have_content @user.presenter.display_name
  else
    expect(page).to have_content @user.presenter.display_name
  end
end

Then /^I should see link for instructions to sign up$/ do
  expect(page).to have_link('Click here for instructions',
                            href: %r{github.com/AgileVentures/WebsiteOne/tree/develop/docs/solutions_for_signup_issues.md})
end

Given /^the following users exist$/ do |table|
  table.hashes.each do |attributes|
    create(:user, :with_karma, attributes)
  end
end

Given /^the following premium users exist$/ do |table|
  table.hashes.each do |attributes|
    attributes['password'] = 'password' unless attributes['password']
    attributes['password_confirmation'] = 'password' unless attributes['password_confirmation']
    user = User.create(attributes)
    set_user_as_premium(user)
  end
end

Given /^the following active users exist$/ do |table|
  table.hashes.each do |attributes|
    project = Project.find_by(title: attributes['projects'])
    Delorean.time_travel_to(attributes['updated_at']) if attributes['updated_at']
    user = create(
      :user,
      first_name: attributes['first_name'],
      last_name: attributes['last_name'],
      email: attributes['email'],
      latitude: attributes['latitude'],
      longitude: attributes['longitude']
    )
    Delorean.back_to_the_present if attributes['updated_at']
    user.follow project
  end
end

Given /^the following statuses have been set$/ do |table|
  table.hashes.each do |attributes|
    user = User.find_by_first_name(attributes[:user])
    create(:status, status: attributes[:status], user_id: user.id)
  end
end

When(/^I click pulldown link "([^"]*)"$/) do |text|
  page.find(:css, '.dropdown .dropdown-menu.dropdown-menu-right .fa-user').click
  first(:link, text).click
end

Given(/^I should be on the "([^"]*)" page for "(.*?)"$/) do |page, user|
  this_user = User.find_by_first_name(user) || User.find_by_email(user)
  expect(current_path).to eq path_to(page, this_user)
end

Given(/^I should be on the anonymous profile page$/) do
  expect(current_path).to eq('/users/-1')
end

Given(/^I (?:am on|go to|should be on) my "([^"]*)" page$/) do |page|
  page.downcase!
  case page
  when 'profile'
    visit user_path(@user)
  when 'edit profile'
    visit edit_user_registration_path(@user)
  else
    pending
  end
end

Given /^I am on "(.*?)" page for user "(.*?)"$/ do |page, user_name|
  user = if user_name == 'me'
           @user
         else
           User.find_by_first_name(user_name)
         end

  case page
  when 'profile'
    visit user_path(user)
  when page == 'edit profile'
    visit edit_user_registration_path(user)
  end
end

Then(/^I (should not|should)? see my email$/) do |option|
  if option == 'should'
    expect(page).to have_content @user.email
  else
    expect(page).to_not have_content @user.email
  end
end

When(/^I set my ([^"]*) to be (public|private)?$/) do |value, option|
  value = value.underscore
  if option == 'public'
    check("user_display_#{value}")
  else
    # uncheck "Display #{value}"
    find("input#user_display_#{value}").set(false)
    expect(find("input#user_display_#{value}")).to_not be_checked
  end
end

When(/^I set ([^"]*) to be (true|false)?$/) do |value, option|
  value = value.underscore
  if option == 'true'
    check("user_#{value}")
  else
    uncheck "user_#{value}"
    expect(find("input#user_#{value}")).to_not be_checked
  end
end

Given(/^My ([^"]*) was set to (public|private)?/) do |value, option|
  @user.update("display_#{value.underscore}".to_sym => (option == 'public'))
end

Then(/^"([^"]*)" (should|should not) be checked$/) do |name, option|
  if option == 'should'
    expect(page.find(:css, "input#user_#{name.underscore}")).to be_checked
  else
    expect(page.find(:css, "input#user_#{name.underscore}")).to_not be_checked
  end
end

Given(/^user "(.*?)" follows projects:$/) do |user, table|
  @user = User.find_by_first_name user
  table.hashes.each do |project|
    step %(I should become a member of project "#{project[:title]}")
  end
end

Given(/^user "(.*?)" have karma:$/) do |user, table|
  @user = User.find_by_first_name user
  table.hashes.each do |karma|
    @user.karma.update(
      hangouts_attended_with_more_than_one_participant: karma[:hangouts_attended_with_more_than_one_participant],
      total: karma[:total]
    )
  end
end

Then(/^the karma summary is "([^"]*)"$/) do |value|
  expect(page).to have_css('span.karma-summary')
  expect(page).to have_css('span.karma-summary .fa.fa-fire')
  expect(page.find(:css, 'span.karma-summary')).to have_content value
end

Given(/^I am logged in as "([^"]*)"$/) do |first_name|
  @user = User.find_by_first_name first_name
  visit new_user_session_path
  within('#main') do
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: test_user_password
    click_button 'Sign in'
  end
end

Given(/^I visit (.*)'s profile page$/) do |name|
  user = User.find_by_first_name name
  visit user_path user
end

Given(/^I am on my profile page$/) do
  visit user_path @current_user
end

Given(/^I (?:have|add) (?:skill|skills) "(.*)"/) do |skills|
  @user.skill_list.add(skills, parse: true)
  @user.save
  @user.reload
end

Given(/^I add a new skill: "(.*)"/) do |skills|
  skills.split(',').each { |s| page.execute_script "$('#skills').tags().addTag('#{s}')" }
end

And(/^I have a GitHub profile with username "([^"]*)"$/) do |username|
  @github_profile_url = "https://github.com/#{username}"
end
When(/^my profile should be updated with my GH username$/) do
  @user.github_profile_url = @github_profile_url
  @user.save
  expect(@user.github_profile_url).to eq @github_profile_url
end

And(/^I have authentication enabled with my github username$/) do
  @user.github_profile_url = @github_profile_url
  @user.save
  @authentication = FactoryBot.create(:authentication, user_id: @user.id, provider: 'github', uid: 42_672)
  @authentication.save
end

Then(/^I should not have github_profile_url set in my profile$/) do
  @user.reload
  expect(@user.github_profile_url).to be_nil
end

Then(/^I should not have any authentications by my github username$/) do
  expect(@user.authentications.find_by(provider: 'github')).to be_nil
end

Then(/^I should see GitHub account unlinking failed message$/) do
  expect(page).to have_content 'Failed to unlink GitHub. Please use another provider for login or reset password.'
end

Given(/^I fetch the GitHub contribution statistics$/) do
  GithubCommitsJob.run
end

When(/^I delete my profile$/) do
  @user.delete
end

# NOTE: search steps below

When(/^I filter "(.*?)" for "(.*?)"$/) do |list_name, selected_from_list|
  steps %(
    When I select "#{selected_from_list}" from the "#{list_name}" list
    And I click "Search"
  )
end

When(/^I select "(.*?)" from the "(.*?)" list$/) do |selected_from_list, list_name|
  filter = case list_name
           when 'projects'
             'project_filter'
           when 'online status'
             'online'
           end

  page.select(selected_from_list, from: filter)
end

When(/^I search for user with email "([^"]*)"$/) do |email|
  visit "/users?email=#{email}"
end

Given(/^I have an incomplete profile$/) do
  @user.bio = ''
  @user.save
end

Given(/^there are an extra (\d+) users$/) do |number|
  number.to_i.times { FactoryBot.create(:user) }
end

And(/^I am on the members page$/) do
  visit '/users'
end

And(/^I click on page "([^"]*)" of users$/) do |page|
  click_link page
end

When(/^I click Karma link for "([^"]*)"$/) do |user_name|
  user = User.find_by_first_name(user_name)
  link = user_path(user)
  page.find(:css, %(a[href="#{link}?tab=activity"])).trigger('click')
end

Then(/^I should not exist as a user$/) do
  user = User.find_by(first_name: 'Anders')
  expect(user).to be_nil
end

And(/^the page should contain the google adwords conversion code/) do
  script = page.all('script', visible: false).inject('') { |m, el| m << el.native.text }
  expect(script).to include 'Zms8CLTN-20Q-NGSmwM'
end

And(/^the user "([^"]*)" should have karma$/) do |email|
  user = User.find_by email: email
  expect(user.karma).not_to be_nil
end
