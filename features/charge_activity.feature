@javascript @vcr
Feature: Charge Users Money
  As a site admin
  So that users can pay for premium services
  I would like to be able to sign them up for a recurring plan

  Scenario: Sign up for premium membership
    Given I visit "/charges/new"
    And I click "Sign Me Up!"
    And I fill in appropriate card details
    And I should see "Thanks, you're now an AgileVentures Premium Member!"