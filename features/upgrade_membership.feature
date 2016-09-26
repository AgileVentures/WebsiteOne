Feature: Allow Users to Upgrade Membership
  As a site admin
  So that users can pay for better premium services
  I would like to be able to upsell them

  Scenario: User upgrades to premium from free tier
    Given I am logged in
    And I am on my profile page
    And I click "Upgrade to Premium"

  Scenario: User upgrades to premium plus from premium
    Given I am logged in as a premium user with name "John", email "john@john.com", with password "asdf1234"
    And I am on my profile page
    And I click "Upgrade to PremiumPlus"