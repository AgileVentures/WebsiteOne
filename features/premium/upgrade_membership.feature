@stripe_javascript @javascript
Feature: Allow Users to Upgrade Membership
  As a site admin
  So that we can achieve financial stability
  I would like users to be able to upgrade their premium plans

  As a software developer
  So that I can receive additional support in my professional development journey
  I would like to be able to upgrade my support plan, and understand what that plan includes

  Background:
    Given the following plans exist
      | name         | id          | amount | free_trial_length_days |
      | Premium      | premium     | 1000   | 7                      |
      | Premium Mob  | premiummob  | 2500   | 0                      |
    And the following users exist
      | first_name | last_name | email                  | github_profile_url         | last_sign_in_ip |
      | Alice      | Jones     | alice@btinternet.co.uk | http://github.com/AliceSky | 127.0.0.1       |

  Scenario: User is on free tier and looking at own page
    Given I am logged in
    And I am on my profile page
    Then I should see "Basic Member"
    And I should not see "Premium Member"
    And I should not see "Premium Mob Member"

  Scenario: User is on free tier and looking at other persons profile page
    Given I am logged in
    And I visit Alice's profile page
    Then I should see "Basic Member"
    And I should not see "Premium Member"
    And I should not see "Premium Mob Member"
    And I should not see button "Upgrade to Premium"
    And I should not see button "Upgrade to Premium Mob"

  Scenario: User upgrades to premium from free tier
    Given I am logged in
    When I am on my profile page
    Then I should see a tooltip explanation of Premium
    And I click "Upgrade to Premium"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should see "Premium Member"
    And my profile page should reflect that I am a "Premium" member
    And I should see button "Upgrade to Premium Mob"
    And I should see myself in the premium members list

  Scenario: User upgrades to premium mob from premium
    Given I am logged in as a premium user with name "John", email "john@john.com", with password "asdf1234"
    When I am on my profile page
    Then I should see a tooltip explanation of Premium Mob
    And I click "Upgrade to Premium Mob"
    Then I should see "Premium Mob Member"
    And I should not see button "Upgrade to Premium Mob"
    And my profile page should reflect that I am a "Premium Mob" member

  Scenario: User tries to upgrade to premium mob from premium but fails
    Given I am logged in as a premium user with name "John", email "john@john.com", with password "asdf1234"
    And I am on my profile page
    And there is a card error updating subscription
    And I click "Upgrade to Premium Mob"
    Then I should see "The card was declined"
    And I should not see "Premium Mob Member"
    Given I am on my profile page
    Then I should not see "Premium Mob Member"
    Then I should not see "Basic Member"
    And I should see "Premium Member"
    And I should see button "Upgrade to Premium Mob"

  Scenario: User upgrades to premium mob from premium via PayPal but fails
    Given I am logged in as a premium user paid for the plan via PayPal
    And I am on my profile page
    Then I should see "Premium Member"
    When I click "Upgrade to Premium Mob"
    Then I should see "We're sorry but we can't automatically upgrade your plan at this time"
    And I should not see "Premium Mob Member"
    Given I am on my profile page
    Then I should not see "Premium Mob Member"
    Then I should not see "Basic Member"
    And I should see "Premium Member"
    And I should see button "Upgrade to Premium Mob"

  Scenario: CraftAcademy student upgrades premium plan to premium mob via Stripe but fails
    Given I am logged in as a CraftAcademy premium user
    And I am on my profile page
    Then I should see "Premium Member"
    When I click "Upgrade to Premium Mob"
    Then I should see "We're sorry but we can't automatically upgrade your plan at this time"
    And I should not see "Premium Mob Member"
    Given I am on my profile page
    Then I should not see "Premium Mob Member"
    Then I should not see "Basic Member"
    And I should see "Premium Member"
    And I should see button "Upgrade to Premium Mob"
