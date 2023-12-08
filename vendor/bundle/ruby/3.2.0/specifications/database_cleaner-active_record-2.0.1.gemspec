# -*- encoding: utf-8 -*-
# stub: database_cleaner-active_record 2.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "database_cleaner-active_record".freeze
  s.version = "2.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ernesto Tagwerker".freeze, "Micah Geisel".freeze]
  s.bindir = "exe".freeze
  s.date = "2021-05-08"
  s.description = "Strategies for cleaning databases using ActiveRecord. Can be used to ensure a clean state for testing.".freeze
  s.email = ["ernesto@ombulabs.com".freeze]
  s.homepage = "https://github.com/DatabaseCleaner/database_cleaner-active_record".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Strategies for cleaning databases using ActiveRecord. Can be used to ensure a clean state for testing.".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<database_cleaner-core>.freeze, ["~> 2.0.0"])
  s.add_runtime_dependency(%q<activerecord>.freeze, [">= 5.a"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
  s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  s.add_development_dependency(%q<mysql2>.freeze, [">= 0"])
  s.add_development_dependency(%q<pg>.freeze, [">= 0"])
  s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
end
