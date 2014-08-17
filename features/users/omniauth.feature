Feature: Log in with SSO
  As a _____ who is not logged in
  So that I can log in
  I want to use SSO to log in
  Pivotal tracker story: https://www.pivotaltracker.com/story/show/63047066

Background:
  Given I am on the "Sign in" page

@visitor-does-SSO-no-email
Scenario: User signs up with a GitHub account having no public email (sad path)
  Given I do not exist as a user
  When I click "GitHub"
  Then I should see "Email can't be blank"

@visitor-does-SSO-no-email
Scenario: User signs up with a Google+ account having no public email (sad path)
  Given I do not exist as a user
  When I click "Google+"
  Then I should see "Email can't be blank"

@visitor-does-SSO
Scenario: Sign in with Github: !user, !authentication
  Given I do not exist as a user
  When I click "GitHub"
  Then I should see "Signed in successfully."
  And I should have gained a "github" authentication

@visitor-does-SSO
Scenario: Sign in with G+: !user, !authentication
  Given I do not exist as a user
  When I click "Google+"
  Then I should see "Signed in successfully."
  And I should have gained a "gplus" authentication

@user-does-SSO
Scenario: Sign in with Github: user, !authentication
  Given I exist as a user without any authentication
  When I click "GitHub"
  Then I should see "Signed in successfully."
  And I should have gained a "github" authentication

@user-does-SSO
Scenario: Sign in with G+: user, !authentication
  Given I exist as a user without any authentication
  When I click "Google+"
  Then I should see "Signed in successfully."
  And I should have gained a "gplus" authentication

@user-does-SSO
Scenario: Sign in with Github: user, authentication
  Given I exist as a user with a "github" authentication
  When I click "GitHub"
  Then I should see "Signed in successfully."
  And I should have gained a "github" authentication

@user-does-SSO
Scenario: Sign in with G+: user, authentication
  Given I exist as a user with a "gplus" authentication
  When I click "Google+"
  Then I should see "Signed in successfully."
  And I should have gained a "gplus" authentication

@user-does-SSO
Scenario: Signed in with G+: user, authentication with GitHub
  Given I exist as a user with a "gplus" authentication
  And I click "Google+"
  And I go to the "my account" page
  And I click "GitHub"
  Then I should see "Signed in successfully."
  And I should have gained a "github" authentication

@user-does-SSO
Scenario: Signed in with GitHub: user, authentication with G+
  Given I exist as a user with a "github" authentication
  And I click "GitHub"
  And I go to the "my account" page
  And I click "Google+"
  Then I should see "Signed in successfully."
  And I should have gained a "gplus" authentication

@user-does-SSO
Scenario: redirect to the last visited page after login with Google
  Given I exist as a user
  And I am not logged in
  And I am on Events index page
  And I visit "/users/sign_in"
  When I click "Google+"
  Then I should be on the Events "Index" page

@user-does-SSO
Scenario: redirect to the last visited page after login with Github
  Given I exist as a user
  And I am not logged in
  And I am on Events index page
  And I visit "/users/sign_in"
  When I click "GitHub"
  Then I should be on the Events "Index" page

