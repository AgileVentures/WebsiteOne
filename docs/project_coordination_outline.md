> As a developer
> In order to be familiar with mechanics of project coordination
> I would like to have a document that describes how:

> * discussions are done
* decisions are made
* tools are used to track project items
* commits and accepts are made
* git flow recommendations
* roles are assigned to project members

> And I would like developers to follow it

### Developer Team meetings
Apart from joining the usual AgileVentures standups, we have a weekly developer kickoff meeting just after the Atlantic standup at 16:45 UTC every Wednesday.

### Waffle flow
For any feature request, create a github issue with a clear user story attached to the description. For example:

> **Title:**  
> Image uploading on project description  

> **Description:**  
> As a user,  
> So that I may have a better understanding of the project goals,  
> I would like to see images of the projects goals or accomplishments  

The story should be discussed with the project managers ([Sam](http://github.com/tansaku) and [Raoul](http://github.com/diraulo)) and other developers in a standup or developer meeting to ensure that the feature is in line with the project goals and direction.

Following the discussion, a clear acceptance criteria should now be defined on the story, and if necessary, the story should be split into smaller (preferably independent) stories:

> **Title:**  
> Image uploading on project description  

> **Description:**  
> As a user,  
> So that I may have a better understanding of the project goals,  
> I would like to see images of the project goals or accomplishments  
> Acceptance Criteria:  
> - a user should be able to upload images through Mercury's native interface and attach it to the project description  
> - images should also be rendered in the preview of the description  

It is up to the project managers to prioritize the story by adding priority labels or placing it higher in the relevant waffle column

Stories (rather than chores or bugfixes) in the backlog should then be estimated in a developer meeting. At this point, the story is estimated and ready to begin.

All members are free to start the story and begin pair programming (see Git flow)

Once completed, a pull request should be submitted and the story should be updated with a link to the pull request on GitHub, do not click finish on the story. 

### Git flow:

1. If not already done, create a fork of the main repository on GitHub: https://github.com/AgileVentures/WebsiteOne and clone the repository:

  ```
  $ git clone git@github.com:<username>/WebsiteOne.git
  ```

  This requires SSH keys to be set up on GitHub, for more information, check out this link:
  https://help.github.com/articles/generating-ssh-keys. 

  For more information on setting up the project locally, refer to this document.

2. Branch off from develop and begin development:

  ```
  $ git checkout develop
  $ git checkout -b my-story-name
  ```

3. Developers that wish to collaborate on that story should communicate with the story owner and request a pair programming session, if that is not possible, try to negotiate offline pong

4. When the story is complete:

  merge with the latest upstream/develop branch, so that his pull request contains all the latest changes:
  ```
  $ git fetch upstream 
  $ git merge upstream/develop
  ```

  check that all tests are passing (`Rspec`, `Cucumber` and `Jasmine`)
  ```
  $ bundle exec rspec
  $ bundle exec cucumber
  $ bundle exec rake jasmine:ci
  ```

  * [create a pull request](how_to_submit_a_pull_request_on_github.md) to the main repository's develop branch
  * deploy (if a demo is necessary) on Heroku so that reviewers can view the change on a live site

5. When a pull request is submitted:

  the story enters a discussion stage, where other members and story owners will review the code and collaborate to improve the implementation through comments.

6. The project managers will take the final decision about when to merge the story.
