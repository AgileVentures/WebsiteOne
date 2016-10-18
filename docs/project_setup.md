## Step 1: Basic Project Setup

If you haven't yet done the following:

* Registered on Github
* Installed `git`
* [Forked](https://help.github.com/articles/fork-a-repo/) the WebSiteOne project

and are unsure how to do so then please see this [general guide to getting set up with an AgileVentures project](http://www.agileventures.org/articles/project-setup-new-users) (use https://github.com/AgileVentures/WebsiteOne as the project URL).

## Step 2: Clone the code locally

Get the project dependencies by running these 2 commands in a bash shell terminal

    git clone https://github.com/<your-github-name>/WebsiteOne

**Note:** On OSX El Capitan and above, you may get this error:

    An error occurred while installing eventmachine (1.0.7), and Bundler cannot continue.
    Make sure that `gem install eventmachine -v '1.0.7'` succeeds before bundling.

If you then try to install that gem, it also fails like this: https://github.com/eventmachine/eventmachine/issues/643, which is because OpenSSL is no longer distributed with OSX so you may need to use brew to set it up:

    brew link openssl --force

Then re-try the rails_setup.sh line above and you should be good to go on to the next step.

## Step 3: Install the gems

    bundle install
    
## Step 4: Install javascript dependencies (ensure bower is installed `npm install bower`)

    npm install  

## Step 5: Update the database

    bundle exec rake db:setup
    
## Step 6: Request the .env file
    
    ask one of the admins (e.g. @tansaku or @diraulo) for the project .env file, and also confirm which locale you are working in

## Step 7: Run the tests

    bundle exec rake spec
    bundle exec rake jasmine:ci
    bundle exec rake cucumber

Discuss any errors with the team.

## Step 8. Start the server

    bundle exec rails s

## Troubleshooting

You can find some solutions [on this page](development_environment_set_up.md)


[Note: This page originally at https://github.com/AgileVentures/WebsiteOne/wiki/Project-Setup-%28New-Users%29]
