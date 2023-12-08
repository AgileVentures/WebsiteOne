# -*- encoding: utf-8 -*-
# stub: railroady 1.6.0 ruby lib

Gem::Specification.new do |s|
  s.name = "railroady".freeze
  s.version = "1.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Preston Lee".freeze, "Tobias Crawley".freeze, "Peter Hoeg".freeze, "Javier Smaldone".freeze]
  s.date = "2021-07-30"
  s.description = "Ruby on Rails model and controller UML class diagram generator. Originally based on the 'railroad' plugin and contributions of many others. (`brew install graphviz` before use!)".freeze
  s.email = ["preston.lee@prestonlee.com".freeze, "tcrawley@gmail.com".freeze, "peter@hoeg.com".freeze, "p.hoeg@northwind.sg".freeze, "javier@smaldone.com.ar".freeze]
  s.executables = ["railroady".freeze]
  s.files = ["bin/railroady".freeze]
  s.homepage = "http://github.com/preston/railroady".freeze
  s.licenses = ["GPLv2".freeze]
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Ruby on Rails model and controller UML class diagram generator.".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<activesupport>.freeze, [">= 0"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
  s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
end
