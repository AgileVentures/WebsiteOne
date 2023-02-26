# Contributing to WebSiteOne (WSO)

So you'd like to contribute to the WebSiteOne codebase?  That's wonderful, we're excited to have your help :-)

Please do come and say hello in our [Slack chat](https://agileventures.slack.com/messages/websiteone). You can get an invite by signing up at [AgileVentures](https://www.agileventures.org) or emailing [info@agileventures.org](mailto:info@agileventures.org).  We sometimes have [weekly meetings](https://www.agileventures.org/events/websiteone-planning) to coordinate our efforts and we try to do planning poker voting on tickets before starting work on them.  Feel free to join any [AgileVentures daily scrum](https://www.agileventures.org/events/) to ask questions, to listen in, or just say hi :-)

Getting set up with the system on your local machine can be tricky depending on your platform and your devops skills.

## Getting Started

This describes how to contribute to WebSiteOne:  the tools we use to track and coordinate the work that is happening and that needs to happen. This also describes the *workflow* -- the processes and sequences for getting contributions merged into the project in an organized and coherent way.

First be sure that you've set up your development environment following all the steps
 in **[Setting Up for Development on WebSiteOne _(Project Set Up)_](https://github.com/AgileVentures/WebsiteOne/blob/develop/docs/project_setup.md)**


We keep our code on [GitHub](http://github.com), use [git](https://git-scm.com) for version control and [Github](https://github.com/orgs/AgileVentures/projects) to manage our projects.  Sometimes we use [ZenHub](https://zenhub.com) to organize work on features, chores and bugfixes.



## General Steps
To get involved please follow these steps:

#### 1. Get the system working on your development environment:

   1. [install WSO on your dev environment (locally)](https://github.com/AgileVentures/WebsiteOne/blob/develop/docs/project_setup.md) or [on docker](https://github.com/AgileVentures/WebsiteOne/tree/develop/docker)

   2. get tests passing (unit and integration tests in `spec/` and acceptance tests in `features`)

   3. check that the site can be run manually (locally)

   4. (optional) deploy to a remote (e.g. Heroku, drie, google, etc.) and ensure it runs there

#### 2. Look at what needs to be done on our Github [projects](https://github.com/orgs/AgileVentures/projects) or Zenhub:

  1. review [open PRs](https://github.com/AgileVentures/WebsiteOne/pulls) on GitHub - leave comments or collaborate if interested
  
  2. review [open Issues](https://github.com/AgileVentures/WebsiteOne/issues) on GitHub and leave a comment if you are interested or if you are working on the issue

  3. look through **[ready](https://app.zenhub.com/workspaces/websiteone-57889e4b621243ff527dc7d9/board?repos=15742370)** column - feel free to start work, but always interested to hear chat in slack, scrum wherever

  4. look through **[new issues](https://app.zenhub.com/workspaces/websiteone-57889e4b621243ff527dc7d9/board?repos=15742370)** column - feel free to ask about priority, as these are not prioritised

  5. look at **[backlog](https://app.zenhub.com/workspaces/websiteone-57889e4b621243ff527dc7d9/board?repos=15742370)** - if there is an interesting ticket get it voted on in a scrum or do an [ASYNC Vote](https://github.com/AgileVentures/AgileVentures/blob/master/ASYNC_VOTING.md) in Slack

##### Voting

  In the past, items needed to be voted on before work could start:
  Voting happens in scrums or the weekly meeting (currently Fridays).  Note that even without the meetings you can get a vote on any issue you're thinking of working on by using the Async voting bot in the [#websiteone slack channel](https://agileventures.slack.com/messages/C029E8G80/details/), using the following syntax: `/voter ISSUE NAME https://github.com/AgileVentures/WebsiteOne/issues/number`.

e.g. 

```
/voter make a press-kit link in the footer https://github.com/AgileVentures/WebsiteOne/issues/1738
```

More on how to handle a vote can be found at: https://github.com/AgileVentures/AgileVentures/blob/master/ASYNC_VOTING.md#automated-async-vote

## git and GitHub
Our **default working branch is `develop`**.  We do work by creating branches off `develop` for new features and bugfixes.

Any *feature* should include appropriate Cucumber acceptance tests and RSpec unit tests.  We try to avoid view and controller specs, and focus purely on unit tests at the model and service level where possible.

A *bugfix* may include an acceptance test depending on where the bug occurred, but fixing a bug should start with the creation of a test that replicates the bug, so that any bugfix submission will include an appropriate test as well as the fix itself.

Each developer will usually work with a [fork](https://help.github.com/articles/fork-a-repo/) of the [main repository on Agile Ventures](https://github.com/AgileVentures/WebSiteOne). Before starting work on a new feature or bugfix, please ensure you have [synced your fork to upstream/develop](https://help.github.com/articles/syncing-a-fork/):

```
git pull upstream develop
```

Note that you should be re-syncing often on your feature/bugfix branch to ensure that you are always building on top of very latest develop code.

### Pull Requests: naming, syncing, size
Here is [how to create and submit a pull requests](https://github.com/AgileVentures/WebsiteOne/blob/develop/docs/how_to_submit_a_pull_request_on_github.md).

Every pull request should refer to a corresponding GitHub issue, and when you create feature/bug-fix branches please include the id of the relevant issue, e.g.

```
git checkout -b 799_add_contributing_md
```

Please ensure that each commit in your pull request makes a single coherent change and that the overall pull request only includes commits related to the specific GitHub issue that the pull request is addressing.  This helps the project managers understand the PRs and merge them more quickly.

Whatever you are working on, or however far you get please do open a "Work in Progress" (WIP) [pull request](https://help.github.com/articles/creating-a-pull-request/) (just prepend your PR title with "[WIP]" ) so that others in the team can comment on your approach.  Even if you hate your horrible code :-) please throw it up there and we'll help guide your code to fit in with the rest of the project.


Before you make a pull request it is a great idea to sync again to the upstream develop branch to reduce the chance that there will be any merge conflicts arising from other PRs that have been merged to develop since you started work:

```
git pull upstream develop
```

In your pull request description please include a sensible description of your code and a tag `fixes #<issue-id>` e.g. :

```
This PR adds a CONTRIBUTING.md file and a docs directory

fixes #799
```

which will associate the pull request with the issue.

This all adds up to a work flow that should look something like this:

0) ensure issue has full description of change and has been voted on
1) create branch prefixed with id of issue (moves issue into 'in progress')  
2) create failing test on the branch (acceptance level)  
3) create failing tests (unit level)  
4) get test to pass with functionality  
5) submit pull request with fixes #xyz   
6) pull request reviewed  
7) changes to original PR if required  
8) pull request merged (presence of "fixes #xyz" then moves issue to 'done')
9) code moved to staging and checked against production data clone
10) code moved to production

Acceptance Tests and Caching
----------------------------

We have unit tests in RSpec and acceptance tests in Cucumber.  At the start of the project we were doing unit, controller and view unit tests in RSpec, but have since stepped back from that requirement, finding it seems rather brittle.  For any new functionality we recommend a simple combination of unit tests in RSpec and acceptance tests in Cucumber, and ensuring that as much logic as possible is moved out of views and controllers into models, services, presenters and helpers where they can be easily unit tested.  This allows us to avoid brittle controller and view tests.

We have several challenges with the current acceptance tests.  One is that some of the javascript tests fail intermittently, particularly on CI.  Partly in an attempt to address this issue we added comprehensive [VCR](https://github.com/vcr/vcr) and [PuffingBilly](https://github.com/oesmith/puffing-billy) sandboxing of network interactions in the acceptance tests.  While these caches allow some of our tests to run faster, and avoid us hitting third party services, they can be very confusing to develop against.

The principle is that one should avoid having tests depend on 3rd party systems over the network, and that we shouldn't spam 3rd party remote services with our test runs.  However the reality is more complicated.  For example in talking to 3rd party Stripe, they've said that they are happy to support test run hits "within reason".  Also, a cached network interaction can make it seem like a part of the system is working, when in fact it will fail in production due to a real change to the network service.  The action here should be to delete the relevant cache files, re-run, save the new cache files (which VCR and PuffingBilly should handle for us) and then commit the new cache files to git.

The reality is that it is often difficult to work out which are the relevant cache files (particularly if you're new to the project) and it's easy to mis-understand what's happening with the caches.  A common reaction to seeing lots of cache files (files in `features/support/fixtures/`) when you run `git status` is to add them to `.gitignore` (which happened on LocalSupport and caused lots of confusion) or simply delete them.

There's a Gordian Knot here which is that we'd like it that if a tests passes on your machine, then it should pass on my machine.  However, if the test relies on a 3rd party network service, then all bets are off.  With some reliable network services that's not such a big deal, but it can be very confusing.  If we just add the cache files to `.gitignore` we can get into some very confusing situations where developers don't realise they are running against cached network interactions.  Simply deleting the cache files (`rm -rf features/support/fixtures/`) and re-checking out ( via `git checkout features/support/fixtures/`) is av perfectly reasonable way to get back to a baseline, but you still might be confused about which cache files you should be checking in with your tests.

In the ideal world the `develop` branch would run green for you and there would be no extraneous files.  Then you add your new test and it's implementation.  Once it's all working you will likely have a bunch of cache files.  These should be deleted in the first instance since some may be due to erroneous network interactions as you were developing.  Assuming you have got to a reliable green test stage you can clean up (`rake vcr_billy_caches:reset`) and then re-run.  At this point, if you got another complete green run (for safety just run your new tests) any new cache files are associated with your tests, and these should be checked in to ensure that your new test/functionality will run the same everywhere.

However the above is complicated and we are actively looking for some sort of testing solution that allows us to avoid the intermittent failing tests, maybe dropping the whole caching approach is one way forward.

Airbrake Issues
---------------

Currently Airbrake automatically opens github issues when we have an error on production.  We suspect that a good portion of them are related to performance, i.e. heroku's business model is based on limiting our memory size, and when we run out of memory then some requests die giving the run for longer than 150000ms errors or what have you.


Pull Request Review
-------------------

A project manager will review your pull request as soon as possible.  Usually the project manager will need to sign off in order to merge a pull request.

The project manager will review the pull request for coherence with the specified feature or bug fix, and give feedback on code quality, user experience, documentation and git style.  Please respond to comments from the project managers with explanation, or further commits to your pull request in order to get merged in as quickly as possible.

To maximize flexibility add the project manager as a collaborator to your WebSiteOne fork in order to allow them to help you fix your pull request, but this is not required.

If your tests are passing locally, but failing on CI, please have a look at the fails and if you can't fix, please do reach out to the project manager.


