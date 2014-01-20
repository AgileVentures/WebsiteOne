Feature: Connect to social sites
  As a registered user
  So that I can log in  easily
  I want to connect my account to other authorization services
  Pivotal tracker story: https://www.pivotaltracker.com/story/show/63047066

Background:
  Given I am on the "Sign in" page

Scenario: Log in with GitHub account
  When I click "Login with GitHub"
  Then I should see "You are connected"

  Scenario: Log in with Google + account
    When I click "Login with Google+"
    Then I should see "You are connected"

