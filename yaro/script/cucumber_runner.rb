#!/usr/bin/env ruby
# file: zeus_rspec_runner.rb

#require 'simplecov'
#SimpleCov.start

# Suppress zeus' whining about how it won't use your RAILS_ENV
ENV.delete('RAILS_ENV')

# Zeus 0.13.2 parses options badly. RubyMine will invoke this file like this:
# rspec_runner.rb spec/my_cool_file.rb --require teamcity/spec/runner/formatter/teamcity/formatter --format Spec::Runner::Formatter::TeamcityFormatter
#
# ...but Zeus will parse those options thinking --require is meant for it, and die.
# If the test file is moved to the end, it dies less.
#ARGV.push(ARGV.shift)
ARGV.push(ARGV.shift) unless ARGV[-1].match(/\.rb$/)
# Add cucumber to the beginning of the commands sent to Zeus
ARGV.unshift 'cucumber'
require 'rubygems'
require 'zeus'
load Gem.bin_path('zeus', 'zeus')

#["rspec", "--require", "teamcity/spec/runner/formatter/teamcity/formatter", "--format", "Spec::Runner::Formatter::TeamcityFormatter", "/home/yaro/Projects/forum_agg/spec/factories_spec.rb"]