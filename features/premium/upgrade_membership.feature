@stripe_javascript @javascript
Feature: Allow Users to Upgrade Membership
  As a site admin
  So that users can pay for better premium services
  I would like to be able to upsell them

  Background:
    Given the following plans exist
      | name    | id      |
      | Premium | premium |
      | PremiumPlus | premiumplus |
    And the following users exist
      | first_name | last_name | email                  | github_profile_url         | last_sign_in_ip |
      | Alice      | Jones     | alice@btinternet.co.uk | http://github.com/AliceSky | 127.0.0.1       |

  Scenario: User is on free tier and looking at own page
    Given I am logged in
    And I am on my profile page
    Then I should see "Basic Member"
    And I should not see "Premium Member"
    And I should not see "Premium Plus Member"

  Scenario: User is on free tier and looking at other persons profile page
    Given I am logged in
    And I visit Alice's profile page
    Then I should see "Basic Member"
    And I should not see "Premium Member"
    And I should not see "Premium Plus Member"
    And I should not see button "Upgrade to Premium"
    And I should not see button "Upgrade to Premium Plus"

  Scenario: User upgrades to premium from free tier
    Given I am logged in
    And I am on my profile page
    And I click "Upgrade to Premium"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium
    Then I should see "Premium Member"
    Given I am on my profile page
    Then I should see "Premium Member"
    Then I should not see "Basic Member"
    Then I should not see "Premium Plus Member"
    And I should see button "Upgrade to Premium Plus"
    And I should see myself in the premium members list

  Scenario: User upgrades to premium plus from premium
    Given I am logged in as a premium user with name "John", email "john@john.com", with password "asdf1234"
    And I am on my profile page
    And I click "Upgrade to Premium Plus"
    Then I should see "Premium Plus Member"
    Given I am on my profile page
    Then I should see "PremiumPlus Member"
    Then I should not see "Basic Member"
    And I should not see "Premium Member"
    And I should not see button "Upgrade to Premium"
    And I should not see button "Upgrade to Premium Plus"

  Scenario: User tries to upgrade to premium plus from premium  but fails
    Given I am logged in as a premium user with name "John", email "john@john.com", with password "asdf1234"
    And I am on my profile page
    And there is a card error updating subscription
    And I click "Upgrade to Premium Plus"
    Then I should see "The card was declined"
    And I should not see "Premium Plus Member"
    Given I am on my profile page
    Then I should not see "PremiumPlus Member"
    Then I should not see "Basic Member"
    And I should see "Premium Member"
    And I should see button "Upgrade to Premium Plus"
