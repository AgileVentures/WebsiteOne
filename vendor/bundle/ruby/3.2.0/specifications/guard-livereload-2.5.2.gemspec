# -*- encoding: utf-8 -*-
# stub: guard-livereload 2.5.2 ruby lib

Gem::Specification.new do |s|
  s.name = "guard-livereload".freeze
  s.version = "2.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Thibaud Guillaume-Gentil".freeze]
  s.date = "2016-02-04"
  s.description = "Guard::LiveReload automatically reloads your browser when 'view' files are modified.".freeze
  s.email = "thibaud@thibaud.me".freeze
  s.homepage = "https://rubygems.org/gems/guard-livereload".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Guard plugin for livereload".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<guard>.freeze, ["~> 2.8"])
  s.add_runtime_dependency(%q<guard-compat>.freeze, ["~> 1.0"])
  s.add_runtime_dependency(%q<em-websocket>.freeze, ["~> 0.5"])
  s.add_runtime_dependency(%q<multi_json>.freeze, ["~> 1.8"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 1.3.5"])
end
