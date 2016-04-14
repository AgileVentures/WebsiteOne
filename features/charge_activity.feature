@javascript @vcr
Feature:As a site admin
  So that users can pay for premium services
  I would like to be able to charge them money

  Scenario: Charge a user
    Given I visit "/charges/new"
    And I click "Pay with Card"
    And I fill in appropriate card details
    And I should see "Thanks, you paid $5.00!"
