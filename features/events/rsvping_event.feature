@javascript
Feature: RSVPing AV events
  As an event creator
  In order to see people planning to attend my event
  I would like to be able to confirm attendence

  Background:
    Given the following users exist
      | first_name | last_name | id  | password  | email                  |
      | Alice      | Jones     | 401 | 12345678  | alicejones@hotmail.com |
      | John       | Doe       |     | password  | john@doe.com           |
    And following events exist:
      | name       | description             | category        | creator_id | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks | creator_attendance |
      | ClientMtg  | Weekly client meeting   | ClientMeeting   | 401        | 2018/07/19 11:00:00 UTC | 150      | never   | UTC       |         |                                           |                       | true       |
      | Meeting    | Weekly meeting          | Meeting         | 401        | 2018/07/21 11:00:00 UTC | 150      | weekly  | UTC       |         | 31                                        | 1                     | false      |

  Scenario: Non-logged in users should not see Attend toggle
    Given I am on the "ClientMtg" event page
    Then I should not see "Cannot Attend"
    And I should not see "Attend"

  Scenario: Users who have not created event cannot see Attend toggle
    Given I am logged in as "John"
    When I am on the "ClientMtg" event page
    Then I should not see "Cannot Attend"
    And I should not see "Attend"

  Scenario: Event creator can see Attend toggle after creating event
    Given I am logged in as "Alice"
    When I am creating an event
    And I click "Save"
    Then I should see "Attend"

  # Scenario: Event creator can mention that they cannot attend
  #   Given I am logged in as "Alice"
  #   And I am on the "ClientMtg" event page
  #   When I toggle to Cannot Attend
  #   Then I should see "Alice Jones cannot attend the event"

  Scenario: Should see cannot attend message for repeating events
    Given the date is "2018/07/28 10:00:00 UTC"
    And I am on the "Meeting" event page
    Then I should see "Alice Jones cannot attend the event"

  Scenario: Event creator can see Cannot Attend toggle
    Given I am logged in as "Alice"
    When I am on the "Meeting" event page
    And I should see "Cannot Attend"
    And I should see "Alice Jones cannot attend the event"

  # Scenario: When event creator toggles to Attend, the cannot attend message is not shown
  #   Given I am logged in as "Alice"
  #   And I am on the "Meeting" event page
  #   When I toggle to Attend
  #   Then I should not see "Alice Jones cannot attend the event"
