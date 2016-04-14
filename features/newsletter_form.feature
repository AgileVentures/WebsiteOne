@vcr
Feature: Newsletter form
  As a specific user
  So that I may create a new newsletter
  I want to have a link on my profile

  # credentials for newsletter creators is defined
  # in lib/agile_ventures.rb
  #
  Background:
    Given the following users exist
      | first_name  | last_name | email               |
      | Chesa       | Boudin    | chesa@example.com   |
      | Noob        | Nobody    | nobody@example.com  |

    Given the following newsletters exist
      | subject      | title      | body      | was_sent | sent_at      |
      | My Subject   | My title   | My body   | false    | nil          |
      | My Sent      | yehaa      | fnord     | true     | DateTime.now |

  Scenario: There is a link displayed for Chesa
    Given I am logged in as "Chesa"
    And I am on my "Profile" page
    Then I should see link "New Newsletter"

  Scenario: There is no link displayed for Noob
    Given I am logged in as "Noob"
    And I am on my "Profile" page
    Then I should not see link "New Newsletter"

  Scenario: There is no link displayed for Chesa if logged out
    Given I am on "Profile" page for user "Chesa"
    Then I should not see link "New Newsletter"

  Scenario: Noob visits Newsletter index page
    Given I am logged in as "Noob"
    When I go to the "newsletters index" page
    Then I should not see link "New Newsletter"
    And I should not see link "Edit"
    And I should not see link "Destroy"

  Scenario: Noob visits existing Newsletter
    Given I am logged in as "Noob"
    When I visit unsent newsletter
    Then I should see link "Back"
    And I should not see link "Edit"
    And I should not see button "Send Newsletter Now"

  Scenario: Creating a new Newsletter as privilged User
    Given I am logged in as "Chesa"
    And I am on my "Profile" page
    And I click "New Newsletter"
    Then I should see "Create a new Newsletter"
    And I fill in "Subject" with "The Subject"
    And I fill in "Title" with "My shiny newsletter"
    And I fill in "Body" with "Some overwhelming content"
    And I click "Create"
    Then I should see "Newsletter was successfully created"
    And I should see "My shiny newsletter"
    And I should see button "Send Newsletter Now"

  Scenario: Sending an existing Newsletter as privileged User
    Given I am logged in as "Chesa"
    When I visit unsent newsletter
    Then I should see button "Send Newsletter Now"
    And I click "Send Newsletter Now"
    Then I should see "Newsletter was successfully updated"

  Scenario: Visiting new newsletter form as unprivileged user
    Given I am logged in as "Noob"
    When I go to the "new newsletter" page
    Then I should see "Access rejected"
