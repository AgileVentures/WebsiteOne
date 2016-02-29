How to Submit a WSO Pull Request on Github
==========================================

According to [Rene](http://www.agileventures.org/users/rene-paulokat), the code review process in WSO is something [like this video](https://youtu.be/QEN5-_93gQg)

Assuming that you have the following local setup:

```
$ git remote -v
origin	   git@github.com:YourName/WebsiteOne.git (fetch)
origin	   git@github.com:YourName/WebsiteOne.git (push)
upstream   https://github.com/AgileVentures/WebsiteOne.git (fetch)
upstream   https://github.com/AgileVentures/WebsiteOne.git (push)
```
1) First, make sure you are checked in to the right branch:

```
$ git checkout <your_feature_branch>
```

2) Pull the most recent version of 'develop' from the WSO GitHub repo with

```
$ git pull upstream develop
```

This fetches and merges your current branch with the latest upstream/develop branch. If any conflicts need to be resolved at this step, how you do so will depend on what tools/IDE you use locally. This goes beyond a quick explanation - pair with someone if you get stuck.

3) Run all tests.

4) Push the feature branch up to your GitHub repo with

```
$ git push origin <your_feature_branch>
```

5) When you view this branch on GitHub, click the green button whose tooltip says 'Compare, review, create pull request':

![Compare, review, create pull request](https://dl.dropboxusercontent.com/u/20922989/Screen%20Shot%202014-08-09%20at%2012.36.44%20AM.png)

Or, if you visit your repo shortly after pushing the branch, there will be a prominent notice about the push, with a prompt to create a pull request:

![Compare and pull request](https://dl.dropboxusercontent.com/u/20922989/Screen%20Shot%202014-08-09%20at%2011.25.32%20AM.png)

6) Fill out the description including "fixes #123" (replacing 123 with the id of the GitHub issue you've been working on) & a brief description of what you've done and create the pull request.

7) Your branch's last commit will now be tested automatically by [Semaphore CI.](semaphoreci.com) Keep an eye on the result, which typically takes less than 15 minutes to appear:

![passed](https://www.dropbox.com/s/2iiock65a9szf5w/Screenshot%202016-02-29%2011.50.59.png?dl=1)

 This is good,

![failed](https://www.dropbox.com/s/7ru2bcjjdnffp8s/Screenshot%202016-02-29%2011.49.33.png?dl=1)

 while this means that you probably have some work to do. Click on the red cross to be taken to [Semaphore CI.](semaphoreci.com) where you can scroll through the tests to see the failure(s).

8) If your build passed, wait for code review comments, make necessary changes to your code, and repeat the process starting from Step 1 as many times as necessary.

_Once your pull request has been accepted and merged into the application's code base, the related GitHub issue will automatically be closed if you correctly add the appropriate sentence to the description, e.g. 'fixes #123'._