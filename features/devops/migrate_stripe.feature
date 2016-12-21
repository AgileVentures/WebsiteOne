@vcr @rake
Feature: Migrate the stripe data
  As the admin
  So that users can get premium related functionality related to the new data schema
  I want to migrate to the new data structure

  Background:
    Given the following plans exist
      | name         | id          | amount | free_trial_length_days |
      | Premium      | premium     | 1000   | 7                      |
    And the following users exist
      | first_name | last_name | email                  | stripe_customer |
      | Alice      | Jones     | alice@btinternet.co.uk | 345rfyuh        |

  Scenario: Migrate the stripe data to the new architecture
    When I run the rake task for migrating stripe
    Then "alice@btinternet.co.uk" shoud have "345rfyuh" in their subscription