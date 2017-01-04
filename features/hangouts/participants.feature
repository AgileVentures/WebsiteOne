@vcr @disable_twitter
Feature: Seeing participants of past and current hangouts
  As an admin
  So that I can see if people are getting together or not
  I would like to see who was in which past and current hangouts

  As a user
  So that I can make a decision about whether to join a hangout
  I would like to see who is in a hangout

  Background:
    Given the following hangouts exist:
      | Start time | Title        | Project    | Category        | Host  | EventInstance url   | Youtube video id | End time |
      | 11:15      | HangoutsFlow | WebsiteOne | PairProgramming | Alice | http://hangout.test | QWERT55          | 11:25    |
    And the following users exist
      | first_name | last_name | email                  | password | gplus   |
      | Alice      | Jones     | alice@btinternet.co.uk | 12345678 | yt_id_1 |
      | Bob        | Anchous   | bob@btinternet.co.uk   | 12345678 | yt_id_2 |
      | Jane       | Anchous   | jan@btinternet.co.uk   | 12345678 | yt_id_3 |

  Scenario:
    Given a hangout
    And that the HangoutConnection has pinged to indicate the hangout is live
    Then the host should be a participant
    Given that another person joins the hangout
    Then the hangout participants should be updated
    When one person leaves and another joins
    Then there should be three snapshots
    And the hangout participants should still include everyone who ever joined
