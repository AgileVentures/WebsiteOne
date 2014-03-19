Feature: User bio
  As a site user
  In order to get to know other users better
  I would like to see a short bio of a user on his profile page

Background:
  Given the following users exist
    | first_name | last_name | email                   | bio                                        |
    | Alice      | Jones     | alicejones@hotmail.com  | Lives on a farm with many sheep and goats. |
    | Bob        | Butcher   | bobb112@hotmail.com     |                                            |

Scenario: View user's bio details
  When I visit Alice's profile page
  Then I should see "Bio"
  And I should see "Lives on a farm with many sheep and goats."

Scenario: User does not have a bio.
  When I visit Bob's profile page
  Then I should see "No Bio"