Feature: Charge Users Money
  As a site admin
  So that users can pay for premium services via paypal
  I would like to be able to sign them up for a recurring plan via paypal

  Scenario: Sign up for premium membership via paypal
    Given I visit "/charges/paypal"
    And I should see "Agile Ventures Premium Membership"
    Then I should see a paypal form

