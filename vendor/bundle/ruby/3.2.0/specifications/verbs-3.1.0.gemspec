# -*- encoding: utf-8 -*-
# stub: verbs 3.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "verbs".freeze
  s.version = "3.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Andy Rossmeissl".freeze]
  s.date = "2021-09-07"
  s.description = "Conjugates most common english verbs for all persons, tenses, standard aspects, and modern moods (with active diathesis). Standard and exceptional spelling rules are obeyed.".freeze
  s.email = "andy@rossmeissl.net".freeze
  s.executables = ["console".freeze]
  s.files = ["bin/console".freeze]
  s.homepage = "http://github.com/rossmeissl/verbs".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 2.4.0".freeze)
  s.rubygems_version = "3.4.6".freeze
  s.summary = "English verb conjugation in Ruby".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
  s.add_development_dependency(%q<test-unit>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 2.3.4"])
  s.add_runtime_dependency(%q<i18n>.freeze, [">= 0"])
end
