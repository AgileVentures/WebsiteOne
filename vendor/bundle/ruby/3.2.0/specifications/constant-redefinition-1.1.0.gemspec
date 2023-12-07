# -*- encoding: utf-8 -*-
# stub: constant-redefinition 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "constant-redefinition".freeze
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Czarnecki".freeze]
  s.date = "2012-04-09"
  s.description = "Allows you to define constants if not defined on an object and redefine constants without warning".freeze
  s.email = ["me@davidczarnecki.com".freeze]
  s.homepage = "https://github.com/czarneckid/constant-redefinition".freeze
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Allows you to define constants if not defined on an object and redefine constants without warning".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 3

  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
end
