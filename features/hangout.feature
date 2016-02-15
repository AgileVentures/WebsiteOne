Feature: Managing hangouts of scrums and PairProgramming sessions
  In order to manage hangouts of scrums and PP sessions  easily
  As a site user
  I would like to have means of creating, joining, editing and watching hangouts

  Background:
    Given following events exist:
      | name          | description          | category      | start_datetime          | duration | repeats | time_zone |
      | Scrum         | Daily scrum meeting  | Scrum         | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |
      | Retrospective | Weekly retrospective | ClientMeeting | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |
    And the following projects exist:
      | title       | description          | status |
      | WebsiteOne  | greetings earthlings | active |
      | Autograders | greetings earthlings | active |
    And the following users exist
      | first_name | last_name | email                  | password | gplus   |
      | Alice      | Jones     | alice@btinternet.co.uk | 12345678 | yt_id_1 |
      | Bob        | Anchous   | bob@btinternet.co.uk   | 12345678 | yt_id_2 |
      | Jane       | Anchous   | jan@btinternet.co.uk   | 12345678 | yt_id_3 |
    And there are no videos
    And I am logged in
    And I have Slack notifications enabled

  @javascript
  Scenario: Create a hangout for a scrum event
    Given I am on the show page for event "Scrum"
    Then I should see hangout button


  @time-travel-step
  Scenario: Show event details
    Given the date is "2014/02/03 06:50:00 UTC"
    When I am on the show page for event "Scrum"
    Then I should see:
      | Scrum               |
      | Scrum               |
      | Daily scrum meeting |
      | 7:00 AM - 9:30 AM   |

  Scenario: Show hangout details for live event
    Given the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
      | Started at         | 10:25:00 UTC        |
    And the time now is "10:26:00 UTC"
    When I am on the show page for event "Scrum"
    Then I should see:
      | Scrum               |
      | Scrum               |
      | Daily scrum meeting |
    And I should see link "Join now" with "http://hangout.test"

  @javascript
  Scenario: Edit Hangout URL
    Given I am on the show page for event "Scrum"
    And I open the Edit URL controls
    And I fill in "hangout_url" with "http://test.com"
    And I click on the Save button
    Then I should see link "Join now" with "http://test.com"

  @javascript
  Scenario: Cancel Edit Hangout URL
    Given I am on the show page for event "Scrum"
    And I open the Edit URL controls
    Then I should see the Edit URL controls
    And I click on the Cancel button
    Then I should not see the Edit URL controls

  @time-travel-step
  Scenario: Render Join live event link
    Given the date is "2014/02/03 07:01:00 UTC"
    And the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
      | Started at         | 07:00:00 UTC        |

    When I am on the show page for event "Scrum"
    Then I should see link "Join now" with "http://hangout.test"

    When I am on the home page
    Then I should see "Scrum is live!"
    And I should see link "Click to join!" with "http://hangout.test"

  @javascript
  Scenario: Display hangout button on a project's page
    Given I am a member of project "WebsiteOne"
    And I am on the "Show" page for project "WebsiteOne"
    Then I should see hangout button

  Scenario: Display live sessions - basic info
    Given the date is "2014/02/01 11:10:00 UTC"
    And the following hangouts exist:
      | Start time | Title        | Project     | Event         | Category        | Host  | EventInstance url      | Youtube video id | End time | Participants |
      | 11:15      | HangoutsFlow | WebsiteOne  | Scrum         | PairProgramming | Alice | http://hangout.test    | QWERT55          | 11:25    | Alice, Bob   |
      | 11:11      | GithubClone  | Autograders | Retrospective | ClientMeeting   | Bob   | http://hangout.session | TGI345           | 12:42    | Alice, Bob   |
    When I visit "/hangouts"
    Then I should see:

      | Title   |
      | Project |
      | Host    |
      | Join    |
      | Watch   |
    And I should see:
      | 11:15        |
      | 01/02        |
      | HangoutsFlow |
      | WebsiteOne   |
    And I should see the avatar for "Alice"
    And I should see link "Join" with "http://hangout.test"
    And I should see link "Watch" with "http://www.youtube.com/watch?v=QWERT55&feature=youtube_gdata"

    And I should see:
      | 11:11       |
      | 01/02       |
      | GithubClone |
      | Autograders |
    And I should see the avatar for "Bob"
    And I should see link "Join" with "http://hangout.session"
    And I should see link "Watch" with "http://www.youtube.com/watch?v=TGI345&feature=youtube_gdata"

  Scenario: Display live sessions - extra info
    Given the date is "2014/02/01 11:10:00 UTC"
    And the following hangouts exist:
      | Start time | Title        | Project     | Event         | Category        | Host  | Hangout url            | Youtube video id | Participants | End time |
      | 11:15      | HangoutsFlow | WebsiteOne  | Scrum         | PairProgramming | Alice | http://hangout.test    | QWERT55          | Jane, Bob    | 11:25    |
      | 11:11      | GithubClone  | Autograders | Retrospective | ClientMeeting   | Bob   | http://hangout.session | TGI345           | Greg, Jake   | 12:42    |

    When I visit "/hangouts"
    Then I should see:
      | Event        |
      | Category     |
      | Participants |
      | Duration     |
    Then I should see:
      | Scrum           |
      | PairProgramming |
      | 10 min          |
    And I should see the avatar for "Jane"
    And I should see the avatar for "Bob"

    And I should see:
      | Retrospective |
      | ClientMeeting |
      | about 2 hours |

  @javascript
  Scenario: Infinite scroll on hangouts scroll down until no more hangouts
    Given 70 hangouts exists
    When I visit "/hangouts"
    Then I should see 30 hangouts
    And I scroll to bottom of page
    Then I should see 60 hangouts
    And I scroll to bottom of page
    Then I should see 70 hangouts
    And I should see "No more hangouts"
