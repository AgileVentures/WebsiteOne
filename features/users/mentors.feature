@vcr
Feature: list mentors
  As a prospective or current premiumplus member
  So that I can understand who are the AV mentors and what are their backgrounds
  I would like to see a list of AV mentors

  Background:
    And the following users exist
      | first_name | last_name | email                  | title_list |
      | Alice      | Jones     | alicejones@hotmail.com | Mentor     |
      | Bob        | Butcher   | bobb112@hotmail.com    | Premium    |

  Scenario: see mentors
    Given I am on the mentors page
    Then I should see "Alice Jones"
    And I should not see "Bob Butcher"