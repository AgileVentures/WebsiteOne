@stripe_javascript @javascript
Feature: Allow Users to Sponsor other members
  As a user
  So that I can help someone else get premium services
  I would like to be able to pay for their premium service

  Background:
    Given the following plans exist
      | name    | id      |
      | Premium | premium |
    And the following users exist
      | first_name | last_name | email                  | github_profile_url         | last_sign_in_ip |
      | Alice      | Jones     | alice@btinternet.co.uk | http://github.com/AliceSky | 127.0.0.1       |
    And the email queue is clear

  Scenario: User upgrades another user from free tier to premium via card
    Given I am logged in
    And I visit Alice's profile page
    And I click "Sponsor for Premium"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should see "you have sponsored Alice Jones as a Premium Member"
    And "alice@btinternet.co.uk" should receive a "You've been sponsored for AgileVentures Premium Membership" email
    Given I visit Alice's profile page
    Then I should see "Premium Member"
    Then I should not see "Basic Member"
    Then I should not see "Sponsor for Premium"
    And I should not see "Upgrade to Premium"

  Scenario: User upgrades another user from free tier to premium via PayPal
    Given I am logged in
    And I visit Alice's profile page
    And I click "Sponsor for Premium"
    Then I should see a paypal form within the paypal_section
    When Paypal updates our endpoint after sponsoring Alice
    Then I should see "you have sponsored Alice Jones as a Premium Member" in last_response
    Given I visit Alice's profile page
    And "alice@btinternet.co.uk" should receive a "You've been sponsored for AgileVentures Premium Membership" email
    Then I should see "Premium Member"
    Then I should not see "Basic Member"
    Then I should not see "Sponsor for Premium"
    And I should not see "Upgrade to Premium"

  Scenario: non logged in user upgrades another user from free tier to premium
    Given I visit Alice's profile page
    And I click "Sponsor for Premium"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should see "you have sponsored Alice Jones as a Premium Member"
    And "alice@btinternet.co.uk" should receive a "You've been sponsored for AgileVentures Premium Membership" email
    Given I visit Alice's profile page
    Then I should see "Premium Member"
    Then I should not see "Basic Member"
    Then I should not see "Sponsor for Premium"
    And I should not see "Upgrade to Premium"

  Scenario: non logged in user upgrades another user from free tier to premium via PayPal
    Given I visit Alice's profile page
    And I click "Sponsor for Premium"
    Then I should see a paypal form within the paypal_section
    When Paypal updates our endpoint after sponsoring Alice
    Then I should see "you have sponsored Alice Jones as a Premium Member" in last_response
    And "alice@btinternet.co.uk" should receive a "You've been sponsored for AgileVentures Premium Membership" email
    Given I visit Alice's profile page
    Then I should see "Premium Member"
    Then I should not see "Basic Member"
    Then I should not see "Sponsor for Premium"
    And I should not see "Upgrade to Premium"