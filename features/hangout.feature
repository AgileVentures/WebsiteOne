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
    And I should see "Edit hangout link"

  Scenario: Show hangout details
    Given the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
      | Started at         | 10:25:00            |
    And the time now is "10:29:00 UTC"
    When I am on the show page for event "Scrum"
    Then I should see Hangouts details section
    And I should see:
      | Category            |
      | Scrum               |
      | Title               |
      | Daily scrum meeting |
      | Updated             |
      | 4 minutes ago       |
    And I should see link "http://hangout.test" with "http://hangout.test"

  @javascript
  Scenario: Show restart hangout
    Given the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
    When I am on the show page for event "Scrum"
    Then I should see "Restart hangout"
    But the hangout button should not be visible


  @javascript
  Scenario: Restart hangout
    Given the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
    And I am on the show page for event "Scrum"

    When I click the link "Restart hangout"
    Then I should see "Restarting Hangout would update the details of the hangout currently associated with this event."
    And the hangout button should be visible

    When I click the button "Close"
    Then the hangout button should not be visible

  @javascript
  Scenario: Edit URL
    Given I am on the show page for event "Scrum"
    When I click the link "Edit hangout link"
    Then I should see button "Cancel"

    When I fill in "hangout_url" with "http://test.com"
    And I click the "Save" button
    Then I should see link "http://test.com" with "http://test.com"

  @javascript
  Scenario: Cancel Edit URL
    Given I am on the show page for event "Scrum"
    When I click the link "Edit hangout link"
    And I click the button "Close"
    Then I should not see button "Save"

  @time-travel-step
  Scenario: Render Join live event link
    Given the date is "2014/02/03 07:04:00 UTC"
    And the Hangout for event "Scrum" has been started with details:
      | EventInstance link | http://hangout.test |
      | Started at         | 07:00:00            |

    When I am on the show page for event "Scrum"
    Then I should see link "EVENT IS LIVE" with "http://hangout.test"

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
      | Start time | Title        | Project     | Event         | Category        | Host  | EventInstance url      | Youtube video id | End time |Participants|
      | 11:15      | HangoutsFlow | WebsiteOne  | Scrum         | PairProgramming | Alice | http://hangout.test    | QWERT55          | 11:25    |Alice, Bob  |
      | 11:11      | GithubClone  | Autograders | Retrospective | ClientMeeting   | Bob   | http://hangout.session | TGI345           | 12:42    |Alice, Bob  |
    When I visit "/hangouts"
    Then I should see:

      | Title      |
      | Project    |
      | Host       |
      | Join       |
      | Watch      |
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
