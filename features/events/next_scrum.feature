@vcr
Feature: Visibility to the next scrum
  In order to manage hangouts of scrums and PP sessions  easily
  As a site user
  I would like to see when the next scrum is
  So that I can join
  As a scrum leader
  I would like my scrum to be visible to others
  So that people will become interested in my project
  As a member of AgileVentures
  I would like scrums to be visible to others
  So that more people join and contribute to projects

  Background:
    Given following events exist:
      | name          | description          | category        | start_datetime          | duration | repeats | time_zone | repeats_every_n_weeks | repeats_weekly_each_days_of_the_week_mask |
      | Scrum         | Daily scrum meeting  | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |                       |                                           |
      | Earlier       | Weekly retrospective | Scrum           | 2014/02/03 06:30:00 UTC | 15       | never   | UTC       |                       |                                           |
      | Random        | Weekly retrospective | PairProgramming | 2017/01/31 23:30:00 UTC | 15       | never   | UTC       |                       |                                           |
    And the following hangouts exist:
      | Start time          | Title        | Project    | Category | Event        | EventInstance url   | Youtube video id | End time            |
      | 2012-02-04 07:00:00 | HangoutsFlow | WebsiteOne | Scrum    | Repeat Scrum | http://hangout.test | QWERT55          | 2014-02-04 07:02:00 |
      | 2014-02-05 07:00:00 | HangoutsFlow | WebsiteOne | Scrum    | Repeat Scrum | http://hangout.test | QWERT55          | 2014-02-05 07:03:00 |
    And the following projects exist:
      | title       | description          | status |
      | WebsiteOne  | greetings earthlings | active |
      | Autograders | greetings earthlings | active |

  @time-travel-step
  Scenario: Next upcoming scrum on home page
    Given the date is "2014/02/03 07:01:00 UTC"
    When I am on the home page
    Then I should see "Scrum is about to start"

  @time-travel-step
  Scenario: Live scrum on home page
    Given the date is "2014/02/03 07:01:00 UTC"
    And the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
      | Started at         | 07:00:00 UTC        |

    When I am on the home page
    Then I should see "Scrum is live!"
    And I should see link "Click to join!" with "http://hangout.test"

  @javascript @time-travel-step
  Scenario: Show the next scrum join link on all pages
    Given the date is "2014/02/03 07:01:00 UTC"
    Given I am on the show page for event "Random"
    Then I should see "Scrum is live!"
