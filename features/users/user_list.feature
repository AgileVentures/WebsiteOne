Feature: As a site owner
  So I can make collaboration among registered users easier
  I would like to display a index of users with links to user profiles

  Background:
    Given I am on the "home" page
    And the following users exist
      | first_name | last_name | email                   |
      | Alice      | Jones     | alice@btinternet.co.uk  |
      | Bob        | Butcher   | bobb112@hotmail.com     |
      |            | Croutch   | c.croutch@enterprise.us |
      | Dave       |           | dave@dixons.me          |
    And I am logged in as user with email "brett@example.com", with password "12345678"
#  "71.212.123.5" # ipd home (Denver,CO or Renton,WA)
# "208.87.35.103" # websiteuk.com -- Nassau, Bahamas
# "50.78.167.161" # HOL Seattle, WA

  Scenario: Having All Users page
    When I click "Members" within the navbar
    Then I should be on the "our members" page
    And I should see:
      | Test User   |
      | Alice Jones |
      | Bob Butcher |
      | Croutch     |
      | Dave        |
    And I should see "5" user avatars

  # Bryan: Using offline stubs, it would be tedious to manually simulate all possible geo locations...
#  Scenario: Show users location
#    When I click "Our members"
#    Then I should be on the "our members" page
#    And I should see:
#      | Sweden        |
#      | United States |

