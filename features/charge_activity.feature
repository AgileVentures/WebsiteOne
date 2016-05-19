@javascript @vcr
Feature:As a site admin
  So that users can pay for premium services
  I would like to be able to charge them money

  Scenario: Charge a user
    Given I visit "/charges/new"
    And I click "Sign Me Up!"
    And I fill in appropriate card details
    And I should see "Thanks, you're now an AgileVentures Premium Member!"