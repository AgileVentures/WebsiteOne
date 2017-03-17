@vcr
Feature: Escalating Call to Action
  As a site admin
  So that we can move towards sustainability
  I would like users to see an escalating call to action depending on their subscription

  Background:
    Given the following plans exist
      | name        | id         | amount | free_trial_length_days |
      | Premium     | premium    | 1000   | 7                      |
      | Premium Mob | premiummob | 2500   | 0                      |

  Scenario: Guest user sees call to action which links to sign up page
    Given I am on the "home" page
    When I click "Get started now to begin coding on real projects!"
    Then I should be on the "sign up" page

  Scenario: Logged in use sees call to action which links to premium subscription page
    Given I am logged in
    And I am on the "home" page
    When I click "Upgrade to Premium for additional support"
    Then I should be on the "premium sign up" page

  @stripe_javascript @javascript
  Scenario: Premium user sees call to action which links to premium mob subscription page
    Given I am logged in as a premium user with name "John", email "john@gmail.com", with password "12345678"
    And I am on the home page
    When I click "Upgrade to Premium Mob for group sessions with a Mentor"
    Then I should be on the "premium mob sign up" page
