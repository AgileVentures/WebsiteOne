# -*- encoding: utf-8 -*-
# stub: em-synchrony 1.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "em-synchrony".freeze
  s.version = "1.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ilya Grigorik".freeze]
  s.date = "2016-12-02"
  s.description = "Fiber aware EventMachine libraries".freeze
  s.email = ["ilya@igvita.com".freeze]
  s.homepage = "http://github.com/igrigorik/em-synchrony".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Fiber aware EventMachine libraries".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<eventmachine>.freeze, [">= 1.0.0.beta.1"])
end
