# -*- encoding: utf-8 -*-
# stub: gli 2.21.0 ruby lib

Gem::Specification.new do |s|
  s.name = "gli".freeze
  s.version = "2.21.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Copeland".freeze]
  s.bindir = "exe".freeze
  s.date = "2022-01-26"
  s.description = "Build command-suite CLI apps that are awesome.  Bootstrap your app, add commands, options and documentation while maintaining a well-tested idiomatic command-line app".freeze
  s.email = "davidcopeland@naildrivin5.com".freeze
  s.executables = ["gli".freeze]
  s.extra_rdoc_files = ["README.rdoc".freeze, "gli.rdoc".freeze]
  s.files = ["README.rdoc".freeze, "exe/gli".freeze, "gli.rdoc".freeze]
  s.homepage = "http://davetron5000.github.io/gli".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.rdoc_options = ["--title".freeze, "Git Like Interface".freeze, "--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Build command-suite CLI apps that are awesome.".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rdoc>.freeze, [">= 0"])
  s.add_development_dependency(%q<rainbow>.freeze, ["~> 1.1", "~> 1.1.1"])
  s.add_development_dependency(%q<sdoc>.freeze, [">= 0"])
  s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
end
