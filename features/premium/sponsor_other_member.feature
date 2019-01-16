@stripe_javascript @javascript
Feature: Allow Users to Sponsor other members
  As a user
  So that I can help someone else get premium services
  I would like to be able to pay for their premium service

  Background:
    Given the following plans exist
      | name    | id      | amount | free_trial_length_days |
      | Premium | premium | 1000   | 7                      |
    And the following users exist
      | first_name | last_name | email                  | github_profile_url         | last_sign_in_ip |
      | Alice      | Jones     | alice@btinternet.co.uk | http://github.com/AliceSky | 127.0.0.1       |
    And the following premium users exist
      | first_name | last_name | email                | github_profile_url         | last_sign_in_ip |
      | Billy      | Bob       | bob@btinternet.co.uk | http://github.com/BillyBob | 127.0.0.1       |
    And the email queue is clear

  Scenario: User upgrades another user from free tier to premium via card
    Given I have logged in
    And I visit Alice's profile page
    And I click "Sponsor for Premium"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should see "you have sponsored Alice Jones as a Premium Member"
    And "alice@btinternet.co.uk" should receive a "You've been sponsored for AgileVentures Premium Membership" email
    Given I visit Alice's profile page
    Then I should see "Premium Member"
    And I should not see "Basic Member"
    And I should not see "Sponsor for Premium"
    And I should not see "Upgrade to Premium"

  Scenario: User upgrades another user from free tier to premium via PayPal
    Given I have logged in
    And I visit Alice's profile page
    And I click "Sponsor for Premium"
    Then I should see a paypal form within the paypal_section
    When Paypal updates our endpoint after sponsoring Alice
    Then I should see "you have sponsored Alice Jones as a Premium Member" in last_response
    Given I visit Alice's profile page
    And "alice@btinternet.co.uk" should receive a "You've been sponsored for AgileVentures Premium Membership" email
    Then I should see "Premium Member"
    And I should not see "Basic Member"
    And I should not see "Sponsor for Premium"
    And I should not see "Upgrade to Premium"
    And I should be Alice's sponsor

  Scenario: non logged in user upgrades another user from free tier to premium
    Given I exist as a user
    And I visit Alice's profile page
    And I click "Sponsor for Premium"
    Then I should be on the "sign in" page
    When I sign in with valid credentials
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should see "you have sponsored Alice Jones as a Premium Member"
    And "alice@btinternet.co.uk" should receive a "You've been sponsored for AgileVentures Premium Membership" email
    Given I visit Alice's profile page
    Then I should see "Premium Member"
    And I should not see "Basic Member"
    And I should not see "Sponsor for Premium"
    And I should not see "Upgrade to Premium"

  Scenario: non logged in user upgrades another user from free tier to premium via PayPal
    Given I exist as a user
    And I visit Alice's profile page
    And I click "Sponsor for Premium"
    Then I should be on the "sign in" page
    When I sign in with valid credentials
    Then I should see a paypal form within the paypal_section
    When Paypal updates our endpoint after sponsoring Alice
    Then I should see "you have sponsored Alice Jones as a Premium Member" in last_response
    And "alice@btinternet.co.uk" should receive a "You've been sponsored for AgileVentures Premium Membership" email
    Given I visit Alice's profile page
    Then I should see "Premium Member"
    And I should not see "Basic Member"
    And I should not see "Sponsor for Premium"
    And I should not see "Upgrade to Premium"

  Scenario: Different User attempts to update an existing Premium user (and won't see button)
    Given I have logged in
    When I visit Billy's profile page
    Then I should not see button "Sponsor for Premium Mob"
    And I should not see button "Upgrade to Premium Mob"

  Scenario: User upgrades another user from free tier to premium via PayPal, when PayPal POST not working
    Given I have logged in
    And I visit Alice's profile page
    And I click "Sponsor for Premium"
    Then I should see a paypal form within the paypal_section
    # a tighter test would grab the return URL from the form
    When Paypal updates our endpoint after sponsoring Alice via get
    Then I should see "you have sponsored Alice Jones as a Premium Member" in last_response
    Given I visit Alice's profile page
    And "alice@btinternet.co.uk" should receive a "You've been sponsored for AgileVentures Premium Membership" email
    Then I should see "Premium Member"
    And I should not see "Basic Member"
    And I should not see "Sponsor for Premium"
    And I should not see "Upgrade to Premium"
    And I should be Alice's sponsor