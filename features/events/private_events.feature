 @vcr
Feature: Private Events
  As a Premium User of sufficient grade
  In order to be able to join a private mobbing event
  I would like to access the hangout link 
  
  Background:
    Given following events exist:
      | name       | description             | for                    | category        | start_datetime          | duration | repeats | time_zone | project | repeats_weekly_each_days_of_the_week_mask | repeats_every_n_weeks |
      | Mob        | Weekly Mob meeting      | Premium Mob Members    | Mob             | 2014/02/03 07:00:00 UTC | 150      | never   | UTC       |         |                                           |                       |

  Scenario Outline: show mob hangout links to users with correct plans
    Given the I am logged in as a user with "<plan>"
    Given the Hangout for event "Mob" has been started with details:
      | EventInstance link | http://hangout.test |
      | Started at         | 10:25:00 UTC        |
    And the time now is "10:26:00 UTC"
    When I am on the show page for event "Mob"
    Then I <assertion> see a link "Join now" to "http://hangout.test"
    Examples:
      | plan       | assertion  |
      | PremiumF2F | should     |
      | PremiumMob | should     |
      | Premium    | should not |
      | Associate  | should not |
      | Free       | should not |