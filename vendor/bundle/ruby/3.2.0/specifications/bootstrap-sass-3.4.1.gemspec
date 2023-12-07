# -*- encoding: utf-8 -*-
# stub: bootstrap-sass 3.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "bootstrap-sass".freeze
  s.version = "3.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Thomas McDonald".freeze]
  s.date = "2019-02-13"
  s.email = "tom@conceptcoding.co.uk".freeze
  s.homepage = "https://github.com/twbs/bootstrap-sass".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.6".freeze
  s.summary = "bootstrap-sass is a Sass-powered version of Bootstrap 3, ready to drop right into your Sass powered applications.".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<sassc>.freeze, [">= 2.0.0"])
  s.add_runtime_dependency(%q<autoprefixer-rails>.freeze, [">= 5.2.1"])
  s.add_development_dependency(%q<minitest>.freeze, ["~> 5.11"])
  s.add_development_dependency(%q<minitest-reporters>.freeze, ["~> 1.3"])
  s.add_development_dependency(%q<capybara>.freeze, ["~> 3.6"])
  s.add_development_dependency(%q<poltergeist>.freeze, [">= 0"])
  s.add_development_dependency(%q<sassc-rails>.freeze, [">= 2.0.0"])
  s.add_development_dependency(%q<actionpack>.freeze, [">= 4.1.5"])
  s.add_development_dependency(%q<activesupport>.freeze, [">= 4.1.5"])
  s.add_development_dependency(%q<json>.freeze, [">= 1.8.1"])
  s.add_development_dependency(%q<sprockets-rails>.freeze, [">= 2.1.3"])
  s.add_development_dependency(%q<jquery-rails>.freeze, [">= 3.1.0"])
  s.add_development_dependency(%q<slim-rails>.freeze, [">= 0"])
  s.add_development_dependency(%q<uglifier>.freeze, [">= 0"])
  s.add_development_dependency(%q<term-ansicolor>.freeze, [">= 0"])
end
