@javascript @vcr @billy_directories
Feature: Allow Users to Sponsor other members
  As a user
  So that I can help someone else get premium services
  I would like to be able to pay for their premium service

  Background:
    Given the following users exist
      | first_name | last_name | email                  | github_profile_url         | last_sign_in_ip |
      | Alice      | Jones     | alice@btinternet.co.uk | http://github.com/AliceSky | 127.0.0.1       |

  Scenario: User upgrades another user from free tier to premium
    Given I am logged in
    And I visit Alice's profile page
    And I click "Sponsor for Premium"
    When I fill in appropriate card details for premium
    Then I should see "you have sponsored Alice Jones as a Premium Member"
    Given I visit Alice's profile page
    Then I should see "Premium Member"
    Then I should not see "Basic Member"
    Then I should not see "Sponsor for Premium"
    And I should not see "Upgrade to Premium"

  Scenario: non logged in user upgrades another user from free tier to premium
    Given I visit Alice's profile page
    And I click "Sponsor for Premium"
    When I fill in appropriate card details for premium
    Then I should see "you have sponsored Alice Jones as a Premium Member"
    Given I visit Alice's profile page
    Then I should see "Premium Member"
    Then I should not see "Basic Member"
    Then I should not see "Sponsor for Premium"
    And I should not see "Upgrade to Premium"