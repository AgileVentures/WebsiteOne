Feature: As a site user
  To protect my privacy
  I want to decide if which part of my profile should be made public

  Background:
    Given the following users exist
      | first_name  | last_name   | email                   | display_profile |
      | Alice       | Jones       | alice@btinternet.co.uk  |     false       |
      | Bob         | Butcher     | bobb112@hotmail.com     |     true        |


  Scenario: User profile should be public by default
    Given I am not logged in
    And I am on the "Our members" page
    Then I should not see "Alice Jones"
    And I should see "Bob Butcher"

  @enable-custom-errors
  Scenario: Visitor should not be able to access a private profile
    Given I am not logged in
    And I visit Alice's profile page
    Then I should not see "Alice Jones"

  Scenario: Should be able to make my profile private
    Given I am logged in as "Bob"
    And I am on my "Edit Profile" page
    When I set my profile to be private
    Then "Display profile" should not be checked
    And I click "Update"
    And I am on the "Our members" page
    Then I should not see "Bob Butcher" within the main content

  Scenario: Should be able to make my profile public again
    Given I am logged in as "Bob"
    And My profile was set to private
    And I am on my "Edit Profile" page
    Then "Display profile" should not be checked
    When I set my profile to be public
    And I am on the "Our members" page
    Then I should see "Bob Butcher"

  Scenario: Email should be private by default
    Given I am logged in
    And I am on my "Profile" page
    Then I should not see my email

    # Bryan: To be added back later in another story
#  Scenario: Should be preview my email as public
#    Given I am on my profile page
#    When I set my email to be public
#    And I click "Preview"
#    Then "Display email" should be checked
#    And I should see my email in the preview

  @javascript
  Scenario: Should be able to make my email public
    Given I am logged in
    And I am on my "Edit Profile" page
    And "Display email" should not be checked
    When I set my email to be public
    And I click "Update"
    Then I should see my email

  @javascript
  Scenario: Should be able to make my email private again
    Given I am logged in
    And My email was set to public
    And I am on my "Edit Profile" page
    Then "Display email" should be checked
    When I set my email to be private
    And I click "Update"
    And I am on my "Profile" page
    Then I should not see my email

  Scenario: Hire Me button should be private by default
    Given I am logged in
    And I am on my "Profile" page
    Then I should not see button "Hire me"

  @javascript
  Scenario: Should be able to make my Hire Me button public
    Given I am logged in
    And I am on my "Edit Profile" page
    And "Display Hire Me" should not be checked
    When I set my Hire Me to be public
    And I click "Update"
    Then I should see button "Hire me"

  @javascript
  Scenario: Should be able to make my Hire Me button private again
    Given I am logged in
    And My hire me was set to public
    And I am on my "Edit Profile" page
    Then "Display Hire Me" should be checked
    When I set my Hire Me to be private
    And I click "Update"
    And I am on my "Profile" page
    Then I should not see button "Hire me"

    # Bryan: To be added back later in another story
#  Scenario: Should be able to make my email private again
#    Given My email was set to public
#    And I am on my profile page
#    When I set my email to be private
#    And I click "Preview"
#    Then "Display email" should not be checked
#    And I should not see my email in the preview

    # Bryan: To be added back later in another story
  # Scenario: GitHub profiles should be private by default
  #   Given I am on my profile page
  #   When I click "Preview"
  #   Then I should not see a link to my GitHub profile

    # Bryan: To be added back later in another story
  # Scenario: Should be able to make my GitHub profiles public
  #   Given I am on my profile page
  #   When I set my GitHub profile to be public
  #   And I click "Preview"
  #   Then I should see a link to my GitHub profile

    # Bryan: To be added back later in another story
  # Scenario: Should be able to make my GitHub profile private again
  #   Given My GitHub profile was set to public
  #   And I am on my profile page
  #   When I set my GitHub profile to be private
  #   And I click "Preview"
  #   Then I should not see a link to my GitHub profile
