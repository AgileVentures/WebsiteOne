Feature: Allow Users to Upgrade Membership
  As a site admin
  So that users can pay for better premium services
  I would like to be able to upsell them

  Scenario: User is on free tier
    Given I am logged in
    And I am on my profile page
    Then I should see "Basic Member"
    And I should not see "PremiumPlus Member"
    And I should not see "Premium Member"

  Scenario: User upgrades to premium from free tier
    Given I am logged in
    And I am on my profile page
    And I click "Upgrade to Premium"
    Then I should see "Premium Member"
    Then I should not see "PremiumPlus Member"
    Then I should not see "Basic Member"

  Scenario: User upgrades to premium plus from premium
    Given I am logged in as a premium user with name "John", email "john@john.com", with password "asdf1234"
    And I am on my profile page
    And I click "Upgrade to PremiumPlus"
    Then I should see "PremiumPlus Member"
    Then I should not see "Premium Member"
    Then I should not see "Basic Member"