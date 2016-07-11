@vcr
Feature: list users by title
  As a prospective or current premiumplus member
  So that I can understand who are the AV mentors and what are their backgrounds
  As well as what other AV members have premium membership
  I would like to see a list of AV mentors and premium members

  Background:
    And the following users exist
      | first_name | last_name | email                  | title_list      |
      | Alice      | Jones     | alicejones@hotmail.com | Mentor          |
      | Bob        | Butcher   | bobb112@hotmail.com    | Premium         |
      | John       | Jenkins   | john@hotmail.com       | Premium, Plus   |

  Scenario: see mentors
    Given I am on the mentors page
    Then I should see "Alice Jones"
    And I should not see "Bob Butcher"
    And I should see "Mentors Directory"
    And I should see "Check out our 1 awesome mentor from all over the globe"

  Scenario: see premium and premium plus members
    Given I am on the premiums page
    Then I should see "Bob Butcher"
    And I should see "John Jenkins"
    And I should not see "Alice Jones"
    And I should see "Premium Members Directory"
    And I should see "Check out our 2 awesome premium members from all over the globe"