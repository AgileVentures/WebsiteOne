# -*- encoding: utf-8 -*-
# stub: utf8-cleaner 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "utf8-cleaner".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Leon Miller-Out".freeze]
  s.date = "2020-01-23"
  s.description = "Removes invalid UTF8 characters from the URL and other env vars".freeze
  s.email = ["leon@singlebrook.com".freeze]
  s.homepage = "https://github.com/singlebrook/utf8-cleaner".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Prevent annoying error reports of \"invalid byte sequence in UTF-8\"".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<listen>.freeze, ["= 3.0.8"])
  s.add_development_dependency(%q<guard>.freeze, [">= 0"])
  s.add_development_dependency(%q<guard-rspec>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  s.add_development_dependency(%q<rack>.freeze, [">= 0"])
end
