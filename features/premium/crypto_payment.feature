Feature: Allow payment of Premium with crypto
  As a site user
  I would like to be able to pay for my subscription with crypto currency
  So that users can pay for premium services

  Background:
    Given the following plans exist
      | name         | id          | amount | free_trial_length_days |
      | Premium      | premium     | 1000   | 7                      |

  Scenario: User sees an option to pay with crypto on the new subscriptions page
	  Given I exist as a user
	  Given I am logged in
	  When I go to the new subscriptions page
	  Then I should see text "Get Premium with Crypto currency"

	Scenario: User able to view addresses to send crypto to
	 	Given I exist as a user
	  Given I am logged in
	  When I go to the new subscriptions page
	  And I click "Subscribe with Crypto"



  