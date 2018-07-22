Feature: RSVPing AV events
  As an event creator
  In order to see people planning to attend my event
  I would like to be able to confirm attendence
  
  Background: 
    Given the following users exist
      | first_name | last_name | id | password  | email                  |
      | Alice      | Jones     | 4  | 12345678  | alicejones@hotmail.com |                                               
      | John       | Doe       |    | password  | john@doe.com           |
    And following events exist:
      | name       | description             | category        | creator_id | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks | attendance |
      | ClientMtg  | Weekly client meeting   | ClientMeeting   | 4          | 2018/07/19 11:00:00 UTC | 150      | never   | UTC       |         |                                           |                       | true       |
      | Meeting    | Weekly meeting          | Meeting         | 4          | 2018/07/21 11:00:00 UTC | 150      | weekly  | UTC       |         | 31                                        | 1                     | false      |

  Scenario: Non-logged in users should not see Cannot Attend button
    Given I am on the "ClientMtg" event page
    Then I should not see "Cannot Attend"

  Scenario: Regular users cannot see Cannot Attend button
    Given I am logged in as "John"
    When I am on the "ClientMtg" event page
    Then I should not see "Cannot Attend"

  Scenario: project creator can see Cannot Attend button after creating event
    Given I am logged in as "Alice"
    When I am creating an event
    And I click "Save"
    Then I should see "Cannot Attend"

  Scenario: project creator can mention that they cannot attend
    Given I am logged in as "Alice"
    And I am on the "ClientMtg" event page
    When I click "Cannot Attend"
    Then I should see "Alice Jones cannot host the event"

  Scenario: Should see cannot attend message for repeating events
    Given the date is "2018/07/28 10:00:00 UTC"
    And I am on the "Meeting" event page
    Then I should see "Alice Jones cannot host the event"

  Scenario: Project creator can see Attend button
    Given I am logged in as "Alice"
    When I am on the "Meeting" event page
    Then I should not see "Cannot Attend"
    And I should see "Attend"
