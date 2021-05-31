@rake
@stripe_javascript
Feature: Migrate the stripe data
  As the admin
  So that users can get premium related functionality related to the new data schema
  I want to migrate to the new data structure

  Background:
    Given the following plans exist
      | name        | id          | amount | free_trial_length_days |
      | Premium     | premium     | 1000   | 7                      |
      | PremiumMob  | premiummob  | 2500   | 0                      |
      | PremiumF2F  | premiumf2f  | 5000   | 0                      |
      | PremiumPlus | premiumplus | 10000  | 0                      |
    And the following users exist
      | first_name | last_name | email                  |
      | Alice      | Jones     | alice@btinternet.co.uk |
      | Umar       | Hassan    | umar@btinternet.co.uk  |
      | Yi         | Shen      | yi@btinternet.co.uk    |
      | Fidel      | Garcia    | fidel@btinternet.co.uk |
    And the following subscriptions exist
      | type        | user  |
      | Premium     | Alice |
      | PremiumMob  | Yi    |
      | PremiumF2F  | Fidel |
      | PremiumPlus | Umar  |
    And the following payment sources exist
      | type                  | identifier | user  |
      | PaymentSource::Stripe | 345rfyuh   | Alice |
      | PaymentSource::PayPal | 345qwreh   | Umar  |
      | PaymentSource::Stripe | 3478yruw   | Yi    |
      | PaymentSource::PayPal | 3rewasda   | Fidel |

  Scenario: Migrate the stripe data to the new architecture
    When I run the rake task for migrating plans
    Then "alice@btinternet.co.uk" should have a "Premium" subscription plan
    And "umar@btinternet.co.uk" should have a "PremiumPlus" subscription plan
    And "yi@btinternet.co.uk" should have a "PremiumMob" subscription plan
    And "fidel@btinternet.co.uk" should have a "PremiumF2F" subscription plan
