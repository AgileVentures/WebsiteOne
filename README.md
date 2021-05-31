[![Build Status](https://semaphoreci.com/api/v1/agileventures/websiteone/branches/1058_add_google_calendar_link/shields_badge.svg)](https://semaphoreci.com/agileventures/websiteone) [![Maintainability](https://api.codeclimate.com/v1/badges/8bbffaef68e73422ca40/maintainability)](https://codeclimate.com/github/AgileVentures/WebsiteOne/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/8bbffaef68e73422ca40/test_coverage)](https://codeclimate.com/github/AgileVentures/WebsiteOne/test_coverage)

# AgileVentures WebSiteOne

### Legacy code

This [Ruby on Rails](http://rubyonrails.org/) app powers the [AgileVentures main developer site](http://agileventures.org/), showing lists of active [projects](https://www.agileventures.org/projects), [members](https://www.agileventures.org/users), [upcoming events](https://www.agileventures.org/events), [past event recordings](https://www.agileventures.org/scrums), as well as information for how to [get involved](https://www.agileventures.org/membership-plans).

## Installation

See the [Project Setup](docs/project_setup.md) documentation

## Usage

:construction: UNDER CONSTRUCTION :construction:

See the site [How To](docs/how_to_use_the_site.md) documentation

## Contributing

See our [Contribution guidelines](CONTRIBUTING.md)

## History

in 2011, inspired by Dave Patterson and Armando Fox's UCBerkeley Software Engineering Massive Open Online Class (MOOC),  Sam Joseph had the idea for a global online pairing community where everyone worked together to use the agile development methodology to deliver solutions to IT charities and non-profits.  Thomas Ochman joined as project manager and led the development of the WebSiteOne codebase with Bryan Yap serving as technical lead.  Initialy Sam was the notional "client", not getting involved in the tech development, and many different volunteers contributed code.  During this phase the events, projects and user systems were developed.  There was also a blog like articles system.  Yaro Appletov led a tight integration with Google hangouts to allow recordable hangouts to be launched from the site and report back telemetry.

Later Raoul Diffou joined to take over as project manager as Thomas and Bryan had less and less time for the project.  Sam took over the technical lead role in 2016 and also stared pairing with Raoul as project manager.  Later in 2016 as Raoul had less and less time Sam became the sole project manager.  During the course of 2016 Sam and long time AV contributor Michael revised the events framework, and replaced the articles system with a Premium payments framework intended to help ensure AV was sustainable into the future.  In 2017 Google withdrew their Hangouts API breaking various functionality in the site.  Sam and Lokesh Sharma replaced the API integration with manual updates, and Sam pulled in the agile-bot node microservice so that WSO now communicates directly with Slack to alert members about new online meetings and their recordings.

## Approaches

* Agile Development
  * We try to work from user stories in regular sprints, offer daily standups, and get regular feedback from end users.  We try to reflect regularly on our process and experiment with incremental changes to how we get things done.
* Behaviour Driven Development (BDD)
  - We use Cucumber and RSpec testing tools that describe the behaviours of the system and its units
  - We try to work outside in, starting with acceptance tests, dropping to integration tests, then unit tests and then writing application code
  - We do spike application code occasionally to work out what's going on, but then either throw away the spike, or make sure all our tests break before wrapping the application code in tests (by strategically or globally breaking things)
  - Where possible we go for declarative over imperative scenarios in our acceptance tests, trying to boil down the high level features to be easily comprehensible in terms of user intention
* Domain Driven Design (DDD)
  - Sometimes we switch to inside out, trying to adjust the underlying entity schema to better represent the domain model
* Self-documenting code
  - We prefer executable documentation (tests) and relatively short methods where the method and variable names effectively document the code

## Reading material

* [Imperative vs Declarative Cucumber](http://fasteragile.com/blog/2015/01/19/declarative-user-stories-translate-to-good-cucumber-features/)
* [JavaScript Acceptance test trials](https://bibwild.wordpress.com/2016/02/18/struggling-towards-reliable-capybara-javascript-testing/)

## Walkthroughs

* An example of a simple interface change
  * Here is the original [user story](features/jitsi_meet/start_jitsi_button.feature#L1)
  * Here is the original [cucumber scenario](features/jitsi_meet/start_jitsi_button.feature#L15)
  * We did not write a spec, as this would have involved a view spec which we don't feel add any value
  * Here's the [code](app/views/events/show.html.erb#L38) that implemented the feature
  
:construction: UNDER CONSTRUCTION :construction:  
  
* An example of a new feature involving a database change
  ...
* An example of a bug fix
  ...
