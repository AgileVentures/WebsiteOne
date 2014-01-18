Feature: Create and maintain projects
  In order to manage my account settings
  As I user I would like to have a "My account" page
  And I would like to be able to edit change my credentials

  Background:
    Given I am logged in as user with email "current@email.com", with password "12345678"
    And I am on the "home" page

  Scenario: Having My account page
    When I click "My Account"
    Then I should see "Edit your details:"
    And I should see a form with:
      | Field                 |                     |
      | Email                 | current@email.com   |
      | Password              |                     |
      | Password confirmation |                     |
      | Current password      |                     |

  Scenario: Editing details: successful
    Given I click "My Account"
    And I fill in:
      | Field                 | Text      |
      | Email                 | a@a.com   |
      | Password              | 87654321  |
      | Password confirmation | 87654321  |
      | Current password      | 12345678  |

    When I click the "Update" button
    Then I should be on the "home" page
    And I should see "You updated your account successfully."

  Scenario: Editing details: failure
    Given I follow "My Account"
    And I fill in:
      | Field                 | Text      |
      | Email                 | a@a.com   |
      | Password              | 87654321  |
      | Password confirmation | 87654321  |
      | Current password      | wrong     |

    When I click the "Update" button
    Then I should see "There was an error updating your account."
    And I should see "Current password is invalid"

    Scenario: Security issues (confirmation password)
    Scenario: Security issues (current password)










