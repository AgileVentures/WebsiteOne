Feature: Start jitsi meet
  As a person involved in an project
  So that I can join a scrum of Pair Programming session
  I would like to be able to start jitsi meet from event page and project page
  
  Background:
    Given the following projects exist:
      |title | description | status |
      | LS   | LS          | active |
    Given following events exist:
      | name         | description         | category | start_datetime   | duration | repeats | time_zone | repeats_every_n_weeks | repeats_weekly_each_days_of_the_week_mask | project |
      | Scrum        | Daily scrum meeting | Scrum    | 2014 Feb 4th 7am | 15       | never   | UTC       |                       |                                           |  LS     |
      | Repeat Scrum | Daily scrum meeting | Scrum    | 2014 Feb 3rd 7am | 15       | weekly  | UTC       | 1                     | 31                                        |         |
    And I am logged in

  Scenario: Start jitsi meet
    Given the date is "2014 Feb 5th 6:55am"
    And I navigate to the show page for event "Scrum"
    Then I should see a start jitsi meet button
    
  #TODO: Write for project page