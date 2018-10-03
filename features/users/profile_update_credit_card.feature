@stripe_javascript @javascript
Feature: Update credit card from user profile
  As a premium user
  So that I am able to continue accessing/paying for cool premium services
  I would like to be able to update my credit card details when necessary

Background:
  Given the following plans exist
    | name         | id          | amount | free_trial_length_days |
    | Premium      | premium     | 1000   | 7                      |
  And the following users exist
    | first_name | last_name | email                   | latitude | longitude | updated_at    |
    | Alice      | Jones     | alice@btinternet.co.uk  | 59.33    | 18.06     | 1 minute ago  |
