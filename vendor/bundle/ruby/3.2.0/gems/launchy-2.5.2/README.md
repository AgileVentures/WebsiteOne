# launchy

[![Build Status](https://copiousfreetime.semaphoreci.com/badges/launchy/branches/main.svg)](https://copiousfreetime.semaphoreci.com/projects/launchy)

* [Homepage](https://github.com/copiousfreetime/launchy)
* [Github Project](https://github.com/copiousfreetime/launchy)

## DESCRIPTION

Launchy is helper class for launching cross-platform applications in a fire and
forget manner.

There are application concepts (browser, email client, etc) that are common
across all platforms, and they may be launched differently on each platform.
Launchy is here to make a common approach to launching external applications from
within ruby programs.

## FEATURES

Currently only launching a browser is supported.

## SYNOPSIS

You can use launchy on the commandline, within the Capybara and Rspec-rails
testing environment, or via its API.

### Commandline

    % launchy https://www.ruby-lang.org/

There are additional command line options, use `launchy --help` to see them.

### Using the `BROWSER` environment variable

Launchy has a predefined set of common browsers on each platform that it
attempts to use, and of course it is not exhaustive. As a fallback you can make
use of the somewhat standard `BROWSER` environment variable.

`BROWSER` works in a similar same way to `PATH`. It is a colon (`:`) separated
list of commands to try. You can also put in a `%s` in the command and the URL
you are attempting to open will be substituted there.

As an example if you set `BROWSER=/usr/local/bin/firefox-bin -new-tab
'%s':/usr/local/bin/google-chrome-stable` and you call
`Launchy.open("https://www.ruby-lang.org/")` then Launchy will try, in order:

* `/usr/local/bin/firefox-bin -new-tab 'https://www.ruby-lang.org'`
* `/usr/local/bin/google-chrome-stable https://www.ruby-lang.org`

Additional links on the use of `BROWSER` as an environment variable.

* http://www.catb.org/esr/BROWSER/index.html
* https://help.ubuntu.com/community/EnvironmentVariables
* https://wiki.archlinux.org/index.php/environment_variables

### Capybara Testing

First, install [Capybara](https://github.com/jnicklas/capybara) and [Rspec for
Rails](https://github.com/rspec/rspec-rails). Capybara provides the following
method:

    save_and_open_page

When inserted into your code at the place where you would like to open your
program, and when rspec is run, Capybara displays this message:

    Page saved to /home/code/my_app_name/tmp/capybara/capybara-current-date-and-time.html with save_and_open_page.
    Please install the launchy gem to open page automatically.

With Launchy installed, when rspec is run again, it will launch an unstyled
instance of the specific page. It can be especially useful when debugging errors
in integration tests. For example:

    context "signin" do
      it "lets a user sign in" do
        visit root_path
        click_link signin_path
        save_and_open_page
        page.should have_content "Enter your login information"
      end
    end

### Public API

In the vein of [Semantic Versioning](https://semver.org), this is the sole
supported public API.

    Launchy.open( uri, options = {} ) { |exception| }

At the moment, the only available options are:

    :debug        Turn on debugging output
    :application  Explicitly state what application class is going to be used
    :host_os      Explicitly state what host operating system to pretend to be
    :ruby_engine  Explicitly state what ruby engine to pretend to be under
    :dry_run      Do nothing and print the command that would be executed on $stdout

If `Launchy.open` is invoked with a block, then no exception will be thrown, and
the block will be called with the parameters passed to `#open` along with the
exception that was raised.

### An example of using the public API:

    Launchy.open( "https://www.ruby-lang.org" )

### An example of using the public API and using the error block:

    uri = "https://www.ruby-lang.org"
    Launchy.open( uri ) do |exception|
      puts "Attempted to open #{uri} and failed because #{exception}"
    end

## UPGRADING from versions before 2.0.0

The previously published version of Launchy before the 2.0.0 series was 0.4.0.
There have been so many changes, and a mistaken tag at 1.0.0, that I have
decided to bump all the way to 2.x.y.

I have attempted to keep backward compatibility with the previous examples. The
previous API examples of:

    Launchy::Browser.run("https://www.ruby-lang.org/")

and

    Launchy::Browser.new.visit("https://www.ruby-lang.org/")

will still work, and you will get a deprecation notice, along with the line
of code you should probably update. For example, this is what would print out
in the github gem if it was updated to use 2.0.x but not use the supported API.

    % gh home
    WARNING: You made a call to a deprecated Launchy API. This call should be changed to 'Launchy.open( uri )'
    WARNING: I think I was able to find the location that needs to be fixed. Please go look at:
    WARNING:
    WARNING: /Users/jeremy/.rvm/gems/ruby-1.8.7-p334/gems/github-0.6.2/lib/commands/helpers.rb:275:in `open'
    WARNING: helper :open do |url|
    WARNING:   has_launchy? proc {
    WARNING:     Launchy::Browser.new.visit url
    WARNING:   }
    WARNING: end
    WARNING:
    WARNING: If this is not the case, please file a bug. Please file a bug at https://github.com/copiousfreetime/launchy/issues/new

These deprecation notices will go away with version 3.0 and the only available
API will be the documented one.

## ISC LICENSE

https://opensource.org/licenses/isc-license.txt

Copyright (c) 2007-2020 Jeremy Hinegardner

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice
and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

