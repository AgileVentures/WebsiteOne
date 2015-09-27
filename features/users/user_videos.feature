Feature: As a site user
  In order to know the videos started by a member
  I would like to see these videos at the member profile

  Background:
    Given I am logged in
    And the following projects exist:
      | title       | description          | status   | tags            |
      | hello world | greetings earthlings | active   | WSO, WebsiteOne |
      | hello mars  | greetings aliens     | inactive | Autograders     |
    And I am a member of project "hello world"
    And I am a member of project "hello mars"

  Scenario: Show 'no videos' message if there no videos
    Given I go to my "profile" page
    Then I should not see a list of my videos
    And I should see "has no publicly viewable Youtube videos"

  Scenario: show first video's description in the player's heading
    Given I have some videos on project "hello world"
    And my YouTube channel is connected
    When I go to my "profile" page
    Then I should see "PP on hello world - feature: 2" in "video description"

  Scenario: show videos sorted by descending published date
    Given I have some videos on project "hello world"
    And my YouTube channel is connected
    When I go to my "profile" page
    Then I should see "PP on hello world - feature: 2" before "PP on hello world - feature: 1"

  Scenario: show embedded youtube player with the first video
    Given I have some videos on project "hello world"
    And my YouTube channel is connected
    When I go to my "profile" page
    And I should see video "PP on hello world - feature: 2" in "player"

  @javascript
  Scenario: Selecting videos from the list
    Given I have some videos on project "hello world"
    And my YouTube channel is connected
    And I am on my "profile" page
    When I click "PP on hello world - feature: 1"
    Then I should see "PP on hello world - feature: 1" in "video description"
    And I should see video "PP on hello world - feature: 1" in "player"
