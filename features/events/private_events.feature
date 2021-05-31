# Business rules are changing... We are NOT dealing with Premium memberships
# There WILL be a need to restricting access to AV Edge Events in the fall of 2021
# Keeping this logic in the model and these specs for future ref
# @javascript
# @stripe_javascript
# Feature: Private Events
#   "As a Premium User of sufficient grade
#   In order to be able to join a private mobbing event
#   I would like to access the hangout link"

#   Background:
#     Given following events exist:
#       | name | description        | for               | category        | start_datetime          | duration | repeats | time_zone |
#       | Mob  | Weekly Mob meeting | Associate Members | PairProgramming | 2014/02/03 09:00:00 UTC | 150      | never   | UTC       |
#     Given the following plans exist
#       | name         | id          | amount | free_trial_length_days |
#       | Associate    | associate   | 500    | 0                      |
#       | Premium      | premium     | 1000   | 7                      |
#       | Premium Mob  | premiummob  | 2500   | 0                      |
#       | Premium F2F  | premiumf2f  | 5000   | 0                      |
#       | Premium Plus | premiumplus | 10000  | 0                      |

#   Scenario Outline: Premium Mob Members and above see link to join Mobs, watch videos, other users see link to upgrade
#     Given the date is "2014/02/03 10:26:00 UTC"
#     Given I am logged in as a user with "<plan>"
#     Given the Hangout for event "Mob" has been started with details:
#       | EventInstance link | http://hangout.test | yt_video_id |
#       | Started at         | 10:25:00 UTC        | QWERT55     |
#     And the time now is "10:26:00 UTC"
#     When I am on the show page for event "Mob"
#     Then I should see a link to join or upgrade based on my <plan>
#     And I <assertion> see a link to watch the event's past video
#     Examples:
#       | plan      | assertion  |
#       # | Premium Plus | should     |
#       # | Premium F2F  | should     |
#       # | Premium Mob  | should     |
#       # | Premium      | should not |
#       | Associate | should     |
#       | Free      | should not |

#   Scenario: Edit hangout url for private event pings only appropriate private channels
#     Given I have logged in
#     And the date is "2014/02/03 9:00:00 UTC"
#     And that we're spying on the SlackService
#     And the Slack notifications are enabled
#     When I manually set a hangout link for event "Mob"
#     Then the Hangout URL is posted only in appropriate private channels in Slack

#   Scenario: Edit youtube url for private event pings only appropriate private channels
#     Given the date is "2014/02/03 9:00:00 UTC"
#     And I am logged in as a user with "Premium Plus"
#     And that we're spying on the SlackService
#     And the Slack notifications are enabled
#     When I manually set youtube link with youtube id "12341234111" for event "Mob"
#     Then the Youtube URL is posted in select private channels in Slack