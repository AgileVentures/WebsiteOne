# -*- encoding: utf-8 -*-
# stub: ruby-gitter 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-gitter".freeze
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["kristenmills".freeze]
  s.date = "2015-06-28"
  s.description = "Ruby Gitter API Client".freeze
  s.email = ["kristen@kristen-mills.com".freeze]
  s.homepage = "https://github.com/kristenmills/ruby-gitter".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Ruby Gitter API Client".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.5"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<httparty>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<hashie>.freeze, [">= 0"])
end
