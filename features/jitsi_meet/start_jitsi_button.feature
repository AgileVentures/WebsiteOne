Feature: Start jitsi meet
  As a person involved in an project
  So that I can join a scrum of Pair Programming session
  I would like to be able to start jitsi meet from event page and project page

  Background:
    Given the following projects exist:
      | title | description | status |
      | LS    | LS          | active |
    Given following events exist:
      | name         | description         | category | start_datetime   | duration | repeats | time_zone | repeats_every_n_weeks | repeats_weekly_each_days_of_the_week_mask | project |
      | Repeat Scrum | Daily scrum meeting | Scrum    | 2014 Feb 3rd 7am | 15       | weekly  | UTC       | 1                     | 31                                        |         |
    And I have logged in
    And I am on the "Show" page for project "LS"
    And I click the "Join Project" button

  Scenario: Start jitsi meet from event page
    Given the date is "2014 Feb 5th 6:55am"
    And I navigate to the show page for event "Repeat Scrum"
    Then I should see a start jitsi meet button with link "https://meet.jit.si/AV_Repeat_Scrum"

  Scenario: Start jitsi meet from project page
    Given the date is "2014 Feb 5th 6:55am"
    And I am on the "Show" page for project "LS"
    Then I should see a start jitsi meet button with link "https://meet.jit.si/AV_LS"
