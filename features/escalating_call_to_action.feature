@vcr
Feature: Escalating Call to Action
  As a site admin
  So that we can move towards sustainability
  I would like users to see an escalating call to action depending on their subscription

  Scenario: Guest user sees call to action which links to sign up page
    Given I am on the "home" page
    When I click "Sign up now to start coding!"
    Then I should be on the "sign up" page

  Scenario: Logged in use sees call to action which links to premium subscription page
    Given I am logged in
    And I am on the "home" page
    When I click "Upgrade to Premium for additional support"
    Then I should be on the "premium sign up" page

  Scenario: Premium user sees call to action which links to premium mob subscription page
    Given I am logged in as a premium user with name "John", email "john@gmail.com", with password "12345"
    And I am on the "home" page
    When I click "Upgrade to Premium Mob for group sessions with a Mentor"
    Then I should be on the "premium mob sign up" page

  Scenario: Premium Mob user sees call to action which links to premium mob subscription page
    Given I am logged in as a premium mob user with name "John", email "john@gmail.com", with password "12345"
    And I am on the "home" page
    When I click "Upgrade to Premium F2F for individual sessions with a Mentor"
    Then I should be on the "premium f2f sign up" page

    