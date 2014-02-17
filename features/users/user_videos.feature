Feature: As a site owner
  So I can make collaboration among registered users easier
  I would like to display a index of users with links to user profiles

  Background:
    Given I want to use third party authentications
    And I am logged in
    And the following users exist
      | first_name  | last_name   | email                   | password  |
      | Alice       | Jones       | alice@btinternet.co.uk  | 12345678  |

  Scenario: Show 'link your channel' message if my page channel is not linked
    Given my YouTube Channel is not connected
    When I go to my "profile" page
    Then I should not see a list of my videos
    And I should see "Sync with YouTube"

  Scenario: Show 'unlink your channel' message if my channel is connected
    Given my YouTube channel is connected
    When I go to my "profile" page
    Then I should see "Disconnect YouTube"

  Scenario: Do not show 'link your channel' message if not my page
    Given I am on "profile" page for user "Alice"
    And user "Alice" has YouTube Channel not connected
    Then I should not see "Sync with YouTube"

  Scenario: Do not show 'unlink your channel' message if not my page
    Given I am on "profile" page for user "Alice"
    And user "Alice" has YouTube Channel connected
    Then I should not see "Sync with YouTube"

  Scenario: Link my Youtube channel to my account
    Given my YouTube Channel ID with some videos in it
    But my YouTube Channel is not connected
    And I am on my "profile" page
    When I click "Sync with YouTube"
    Then I should see "Title"
    And I should see "Published"
    And I should see a list of my videos
    But I should not see "Sync with YouTube"

  Scenario: Show 'no videos' message if there no videos
    Given my YouTube Channel ID with no videos in it
    And my YouTube channel is connected
    When I go to my "profile" page
    Then I should not see a list of my videos
    And I should see "has no publicly viewable Youtube videos"

  Scenario: show first in video and description, player, filter

  @javascript
  Scenario: Selecting videos from the list
    Given I open my browser
    And my YouTube Channel ID with some videos in it
    And my YouTube channel is connected
    And I am on my "profile" page
    When I click "WebsiteOne - Pairing session"
    Then I should see "WebsiteOne - Pairing session" in "video description"
    And I should see video "WebsiteOne - Pairing session" in "player"
