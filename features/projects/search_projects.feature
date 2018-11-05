@vcr @javascript
Feature: Search for Projects by Language
	As an agile ventures member
	So that I can find a project based on a specific language I would like to work with
	I would like to search projects according to programming language

	Background:
    Given the following projects exist:
      | title         | description             | pitch       | status   | github_url                                  | pivotaltracker_url                               | commit_count | last_github_update      | languages     |
      | hello world   | greetings earthlings    |             | active   | https://github.com/AgileVentures/WebsiteOne | https://www.pivotaltracker.com/s/projects/742821 | 2795         | 2000-01-13 09:37:14 UTC | Node          |
      | hello mars    | greetings aliens        |             | active   |                                             |                                                  | 2000         | 1999-01-11 09:37:14 UTC | Python        |
      | hello jupiter | greetings jupiter folks |             | active   |                                             | https://jira.atlassian.com/projects/CONFEXT      | 2000         | 1999-01-10 09:37:14 UTC | Ruby 				 |
      | hello mercury | greetings mercury folks |             | active   |                                             |                                                  | 1900         | 1999-01-09 09:37:14 UTC | Ruby 				 |
      | hello saturn  | greetings saturn folks  | My pitch... | active   |                                             |                                                  | 1900         | 1999-01-09 08:37:14 UTC | Ruby 				 |
      | hello sun     | greetings sun folks     |             | active   |                                             |                                                  | 1800         | 1999-01-01 09:37:14 UTC | Ruby 				 |
      | hello venus   | greetings venus folks   |             | active   |                                             |                                                  |              | 1999-01-01 09:37:14 UTC | Ruby 				 |
      | hello terra   | greetings terra folks   |             | active   |                                             |                                                  |              | 1999-01-01 09:37:14 UTC | Elixir        |
      | hello pluto   | greetings pluto folks   |             | inactive |                                             |                                                  | 2000         | 1999-01-01 09:37:14 UTC | Ruby 				 |
      | hello alpha   | greetings alpha folks   |             | active   |                                             |                                                  | 300          | 2000-01-12 09:37:14 UTC | Ruby 				 |

	Scenario: Search for projects by their languages
	  Given I am on the "projects" page
		When I filter "project_languages" for "Ruby"
		Then I should see "hello alpha" within "project-list"
	  And I should not see "hello world" within "project-list"

