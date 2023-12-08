# -*- encoding: utf-8 -*-
# stub: http-accept 1.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "http-accept".freeze
  s.version = "1.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Samuel Williams".freeze]
  s.bindir = "exe".freeze
  s.date = "2017-03-14"
  s.email = ["samuel.williams@oriontransfer.co.nz".freeze]
  s.homepage = "https://github.com/ioquatix/http-accept".freeze
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Parse Accept and Accept-Language HTTP headers.".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.11"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
end
