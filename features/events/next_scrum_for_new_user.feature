@vcr
Feature: Visibility to the next scrum for new user
  As an AgileVentures Admin,
  So that new members are more likely to watch and/or attend scrums and other events
  I would like the language in the upcoming event notification to me as welcoming as possible
  Instead of mentioning things like "scrum" and "kent beck" that may be unfamiliar

  As a new member
  So that I can discover if AgileVentures can help me in my professional development
  I would like to learn more about how AV events operate

  Background:
    Given following events exist:
      | name          | description          | category        | start_datetime          | duration | repeats | time_zone | repeats_every_n_weeks | repeats_weekly_each_days_of_the_week_mask |
      | Scrum         | Daily scrum meeting  | Scrum           | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |                       |                                           |
      | Earlier       | Weekly retrospective | Scrum           | 2014/02/03 06:30:00 UTC | 15       | never   | UTC       |                       |                                           |
      | Random        | Weekly retrospective | PairProgramming | 2017/01/31 23:30:00 UTC | 15       | never   | UTC       |                       |                                           |
    And the following projects exist:
      | title       | description          | status |
      | WebsiteOne  | greetings earthlings | active |
      | Autograders | greetings earthlings | active |

  @time-travel-step
  Scenario: Next upcoming scrum on home page
    Given the date is "2014/02/03 06:55:00 UTC"
    When I am on the home page
    Then I should see "Want to learn more? Listen in. Next projects' review meeting in 5 minutes"

  @time-travel-step
  Scenario: Within duration next scrum on home page
    Given the date is "2014/02/03 07:01:00 UTC"
    When I am on the home page
    Then I should see "Want to learn more? Listen in. Next projects' review meeting is about to start"

  @time-travel-step
  Scenario: Live scrum on home page
    Given the date is "2014/02/03 07:01:00 UTC"
    And the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
      | Started at         | 07:00:00 UTC        |
    When I am on the home page
    Then I should see "Want to learn more? Listen in. Next projects' review meeting is live!"
    And I should see link "Click to join!" with "http://hangout.test"

  @javascript @time-travel-step
  Scenario: Within duration scrum displays when not on home page
    Given the date is "2014/02/03 07:01:00 UTC"
    And the window size is wide
    When I am on the show page for event "Random"
    Then I should see "Next projects review meeting - listen in to learn more about AgileVentures"
