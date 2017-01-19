@stripe_javascript @javascript
Feature: Charge Users Money
  As a site admin
  So that users can pay for premium services
  I would like to be able to sign them up for a recurring plan

  Background:
    Given the following plans exist
      | name         | id          | amount | free_trial_length_days |
      | Premium      | premium     | 1000   | 7                      |
      | Premium Mob  | premiummob  | 2500   | 0                      |
      | Premium F2F  | premiumf2f  | 5000   | 0                      |
      | Premium Plus | premiumplus | 10000  | 0                      |
    And the following pages exist
      | title           | body                    |
      | About Us        | Agile Ventures          |
      | Pricing         | wonga                   |
      | Getting Started | Remote Pair Programming |

  Scenario: There should be a link to the premium page on the navbar
    Given I am on the home page
    Then I should see "PREMIUM" within the navigation bar
    When I click "Premium" within the navigation bar
    Then I should be on the static "Pricing" page

  # following four could be converted to scenario outline

  Scenario: Sign up for premium f2f membership
    Given I visit "/subscriptions/new?plan=premiumf2f"
    And I should not see "Sign Me Up For Premium!"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium f2f
    Then I should see "Thanks, you're now an AgileVentures Premium F2F Member!"
    And the user should receive a "Welcome to AgileVentures Premium F2F" email

  Scenario: Sign up for premium plus membership
    Given I visit "/subscriptions/new?plan=premiumplus"
    And I should not see "Sign Me Up For Premium!"
    And I click "Subscribe" within the card_section
    When I fill in appropriate card details for premium plus
    Then I should see "Thanks, you're now an AgileVentures Premium Plus Member!"
    And the user should receive a "Welcome to AgileVentures Premium Plus" email

  Scenario: User decides to change card details
    Given I am logged in as a premium user with name "tansaku", email "tansaku@gmail.com", with password "asdf1234"
    And I visit "subscriptions/tansaku/edit"
    And I click "Update Card Details"
    When I fill in updated card details for premium for user with email "tansaku+stripe@gmail.com"
    Then I should see "Your card details have been successfully updated"

  Scenario: User changes card details, but encounters error
    Given I am logged in as user with name "tansaku", email "tansaku@gmail.com", with password "asdf1234"
    And I visit "subscriptions/tansaku/edit"
    And I click "Update Card Details"
    When I fill in updated card details for premium for user with email "tansaku+stripe@gmail.com"
    Then I should not see "Your card details have been successfully updated"
    And I should see "something has gone wrong with changing your card details."

  Scenario: User cannot change card details if not logged in
    Given I visit "subscriptions/tansaku/edit"
    Then I should be on the "sign in" page