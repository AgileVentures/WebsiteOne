@javascript @vcr @billy_directories
Feature: Allow Users to Upgrade Membership
  As a site admin
  So that users can pay for better premium services
  I would like to be able to upsell them

  Background:
    Given the following users exist
      | first_name | last_name | email                  | github_profile_url         | last_sign_in_ip |
      | Alice      | Jones     | alice@btinternet.co.uk | http://github.com/AliceSky | 127.0.0.1       |

  Scenario: User is on free tier and looking at own page
    Given I am logged in
    And I am on my profile page
    Then I should see "Basic Member"
    And I should not see "Premium Member"

  Scenario: User is on free tier and looking at other persons profile page
    Given I am logged in
    And I visit Alice's profile page
    Then I should not see "Basic Member"
    And I should not see "Premium Member"
    And I should not see "Upgrade to Premium"

  Scenario: User upgrades to premium from free tier
    Given I am logged in
    And I am on my profile page
    And I click "Upgrade to Premium"
    When I fill in appropriate card details for premium
    Then I should see "Premium Member"
    Given I am on my profile page
    Then I should not see "Basic Member"
    And I should not see "Upgrade to Premium"