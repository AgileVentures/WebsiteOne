# -*- encoding: utf-8 -*-
# stub: icalendar 2.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "icalendar".freeze
  s.version = "2.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ryan Ahearn".freeze]
  s.date = "2022-07-11"
  s.description = "Implements the iCalendar specification (RFC-5545) in Ruby.  This allows\nfor the generation and parsing of .ics files, which are used by a\nvariety of calendaring applications.\n".freeze
  s.email = ["ryan.c.ahearn@gmail.com".freeze]
  s.homepage = "https://github.com/icalendar/icalendar".freeze
  s.licenses = ["BSD-2-Clause".freeze, "GPL-3.0-only".freeze, "icalendar".freeze]
  s.post_install_message = "ActiveSupport is required for TimeWithZone support, but not required for general use.\n".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 2.4.0".freeze)
  s.rubygems_version = "3.4.6".freeze
  s.summary = "A ruby implementation of the iCalendar specification (RFC-5545).".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<ice_cube>.freeze, ["~> 0.16"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<bundler>.freeze, ["~> 2.0"])
  s.add_development_dependency(%q<activesupport>.freeze, ["~> 6.0"])
  s.add_development_dependency(%q<i18n>.freeze, ["~> 1.8"])
  s.add_development_dependency(%q<tzinfo>.freeze, ["~> 1.2"])
  s.add_development_dependency(%q<tzinfo-data>.freeze, ["~> 1.2020"])
  s.add_development_dependency(%q<timecop>.freeze, ["~> 0.9"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.8"])
  s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.16"])
end
