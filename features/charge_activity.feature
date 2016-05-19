@javascript @vcr
Feature: Charge Users Money
  As a site admin
  So that users can pay for premium services
  I would like to be able to sign them up for a recurring plan

  Scenario: Sign up for premium membership
    Given I visit "/charges/new"
    And I click "Sign Me Up For Premium!"
    And I fill in appropriate card details for premium
    And I should see "Thanks, you're now an AgileVentures Premium Member!"

  Scenario: Sign up for premium membership
    Given I visit "/charges/new"
    And I click "Sign Me Up For Premium Plus!"
    And I fill in appropriate card details for premium plus
    And I should see "Thanks, you're now an AgileVentures Premium PLUS Member!"