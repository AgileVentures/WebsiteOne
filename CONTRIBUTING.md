Development Process
------------------

Our default working branch is `develop`.  We do work by creating branches off `develop` for new features and bugfixes.  Any feature should include appropriate Cucumber acceptance tests and RSpec unit tests.  We try to avoid view and controller specs, and focus purely on unit tests at the model and service level where possible.  A bugfix may include an acceptance test depending on where the bug occurred, but fixing a bug should start with the creation of a test that replicates the bug, so that any bugfix submission will include an appropriate test as well as the fix itself.

Each developer will usually work with a [fork](https://help.github.com/articles/fork-a-repo/) of the [main repository on Agile Ventures](https://github.com/AgileVentures/WebSiteOne). Before starting work on a new feature or bugfix, please ensure you have [synced your fork to upstream/develop](https://help.github.com/articles/syncing-a-fork/):

```
git pull upstream develop
```

Note that you should be re-syncing daily (even hourly at very active times) on your feature/bugfix branch to ensure that you are always building on top of very latest develop code.

We use [Waffle](https://waffle.io/AgileVentures/WebsiteOne) to manage our work on features, chores and bugfixes.  Every pull request should a corresponding GitHub issue, and when you create feature/bug-fix branches please include the id of the relevant issue, e.g.

```
git checkout -b 799_add_contributing_md
```

Please ensure that each commit in your pull request makes a single coherent change and that the overall pull request only includes commits related to the specific GitHub issue that the pull request is addressing.  This helps the project managers understand the PRs and merge them more quickly.

Whatever you are working on, or however far you get please do open a "Work in Progress" (WIP) [pull request](https://help.github.com/articles/creating-a-pull-request/) so that others in the team can comment on your approach.  Even if you hate your horrible code :-) please throw it up there and we'll help guide your code to fit in with the rest of the project.

In your pull request description please include the following text, :

```
fixes #799
```

which will associate the pull request with the issue in the Waffle board.

Code Style
-------------

We recommend the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide)


