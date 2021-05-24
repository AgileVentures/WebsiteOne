# @vcr
# Feature:
#   "As a developer
#   So that I may see the ranking of articles
#   I would like to see the vote count on an article
#   And ability to vote up or down an article"

#   Background:
#     Given the following articles with votes exist:
#       | Title                    | Content                          | VoteValue |
#       | Ruby is on Fire          | Fire is fire and sunny           | 0         |
#       | Rails is not for trains  | Train `tracks` do not work       | 5         |
#       | JQuery cannot be queried | JQuery moves **towards** the ... | -1        |

#   Scenario: I should see the vote value of an article on the article show page
#     Given I am on the "Show" page for article "Ruby is on Fire"
#     Then I should see a Vote value of "0"
#     Given I am on the "Show" page for article "Rails is not for trains"
#     Then I should see a Vote value of "5"
#     Given I am on the "Show" page for article "JQuery cannot be queried"
#     Then I should see a Vote value of "-1"

#   Scenario: I should not see the links to Up/Down Vote an article on the article show page
#     Given I am not logged in
#     And I am on the "Show" page for article "Ruby is on Fire"
#     Then I should not see link "Up Vote"
#     And I should not see link "Down Vote"

#   Scenario: I should see the links to Up/Down Vote an article on the article show page
#     Given I have logged in
#     And I am on the "Show" page for article "Ruby is on Fire"
#     Then I should see link "Up Vote"
#     And I should see link "Down Vote"

#   Scenario: I should be able to vote up an article
#     Given I have logged in
#     And I have voted "up" article "Ruby is on Fire"
#     And I am on the "Show" page for article "Ruby is on Fire"
#     Then I should see a Vote value of "1"

#   Scenario: I should be able to vote down an article
#     Given I have logged in
#     And I have voted "down" article "JQuery cannot be queried"
#     And I am on the "Show" page for article "JQuery cannot be queried"
#     Then I should see a Vote value of "-2"

#   Scenario: I should see the link to Cancel Up Vote after voting up an article
#     Given I have logged in
#     And I have voted "up" article "Ruby is on Fire"
#     And I am on the "Show" page for article "Ruby is on Fire"
#     Then I should see link "Cancel Up Vote"

#   Scenario: I should see the link to Cancel Down Vote after voting down an article
#     Given I have logged in
#     And I have voted "down" article "Ruby is on Fire"
#     And I am on the "Show" page for article "Ruby is on Fire"
#     Then I should see link "Cancel Down Vote"

#   Scenario: I should be able to cancel an up vote on an article
#     Given I have logged in
#     And I have voted "up" article "Ruby is on Fire"
#     And I am on the "Show" page for article "Ruby is on Fire"
#     And I click the "Cancel Up Vote" link
#     Then I should be on the "Show" page for article "Ruby is on Fire"
#     And I should see a Vote value of "0"

#   Scenario: I should be able to cancel a down vote on an article
#     Given I have logged in
#     And I have voted "down" article "JQuery cannot be queried"
#     And I am on the "Show" page for article "JQuery cannot be queried"
#     And I click the "Cancel Down Vote" link
#     Then I should be on the "Show" page for article "JQuery cannot be queried"
#     And I should see a Vote value of "-1"

# # Down Vote an up voted article

#   Scenario: I should be able to Down vote an up-voted article
#     Given I have logged in
#     And I have voted "up" article "Ruby is on Fire"
#     And I am on the "Show" page for article "Ruby is on Fire"
#     And I click the "Down Vote" link
#     Then I should be on the "Show" page for article "Ruby is on Fire"
#     And I should see a Vote value of "-1"

# # Up Vote a down voted article

#   Scenario: I should be able to Up vote a down-voted article
#     Given I have logged in
#     And I have voted "down" article "JQuery cannot be queried"
#     And I am on the "Show" page for article "JQuery cannot be queried"
#     And I click the "Up Vote" link
#     Then I should be on the "Show" page for article "JQuery cannot be queried"
#     And I should see a Vote value of "0"


# # Author voting for own article

#   Scenario: I should not be able to see vote links on my own article
#     #  clanglois: Following line Implies a log-in
#     Given I have authored article "Rubies are red"
#     And I am on the "Show" page for article "Rubies are red"
#     Then I should not see link "Up Vote"
#     And I should not see link "Down Vote"
#     And I should see a Vote value of "0"

#   Scenario: I should not be able to FORGE upvote on my own article
#     #  clanglois: Following line Implies a log-in
#     Given I have authored article "Rubies are red"
#     And I visit "/articles/rubies-are-red/upvote"
#     Then I should see a Vote value of "0"

#   Scenario: I should not be able to FORGE downvote on my own article
#     #  clanglois: Following line Implies a log-in
#     Given I have authored article "Rubies are red"
#     And I visit "/articles/rubies-are-red/downvote"
#     Then I should see a Vote value of "0"

# # Visiting User voting twice

#   Scenario: I should not be able to vote up twice on same article
#     Given I have logged in
#     And I have voted "up" article "Ruby is on Fire"
#     And I am on the "Show" page for article "Ruby is on Fire"
#     Then I should see a Vote value of "1"
# # 2nd vote
#     And I have voted "up" article "Ruby is on Fire"
#     Then I should be on the "Show" page for article "Ruby is on Fire"
#     And I should see a Vote value of "1"
# # Forge Down Vote url
#     And I visit "/articles/ruby-is-on-fire/upvote"
#     Then I should be on the "Show" page for article "Ruby is on Fire"
#     And I should see a Vote value of "1"


#   Scenario: I should not be able to vote down twice on same article
#     Given I have logged in
#     And I have voted "down" article "Ruby is on Fire"
#     And I am on the "Show" page for article "Ruby is on Fire"
#     Then I should see a Vote value of "-1"
# # 2nd vote
#     And I have voted "down" article "Ruby is on Fire"
#     Then I should be on the "Show" page for article "Ruby is on Fire"
#     And I should see a Vote value of "-1"
# # Forge Down Vote url
#     And I visit "/articles/ruby-is-on-fire/downvote"
#     Then I should be on the "Show" page for article "Ruby is on Fire"
#     And I should see a Vote value of "-1"
