@javascript @vcr @billy_directories
Feature: Charge Users Money
  As a site admin
  So that users can pay for premium services
  I would like to be able to sign them up for a recurring plan

  Background:
    Given the following pages exist
      | title           | body                    |
      | About Us        | Agile Ventures          |
      | Pricing         | wonga                   |
      | Getting Started | Remote Pair Programming |

  Scenario: There should be a link to the premium page on the navbar
    Given I am on the home page
    Then I should see "PREMIUM" within the navigation bar
    When I click "Premium" within the navigation bar
    Then I should be on the static "Pricing" page

  Scenario: Sign up for premium membership
    Given I visit "/charges/new"
    And I should not see "Sign Me Up For Premium Plus!"
    And I click "Sign Me Up For Premium!"
    When I fill in appropriate card details for premium
    Then I should see "Thanks, you're now an AgileVentures Premium Member!"
    And The user should receive a "Welcome to AgileVentures Premium" email

  Scenario: Sign up for premium plus membership
    Given I visit "/charges/new?plan=premiumplus"
    And I should not see "Sign Me Up For Premium!"
    And I click "Sign Me Up For Premium Plus!"
    When I fill in appropriate card details for premium plus
    Then I should see "Thanks, you're now an AgileVentures Premium PLUS Member!"
    And The user should receive a "Welcome to AgileVentures Premium PLUS" email

  Scenario: User decides to change membership
    Given I am logged in as a premium user with name "tansaku", email "tansaku@gmail.com", with password "asdf1234"
    And I visit "charges/tansaku/edit"
    And I click "Update Card Details"
    When I fill in updated card details for premium for user with email "tansaku+stripe@gmail.com"
    Then I should see "Your card details have been successfully updated"

  Scenario: User cannot change card details if not logged in
    Given I visit "charges/tansaku/edit"
    Then I should be on the "sign in" page