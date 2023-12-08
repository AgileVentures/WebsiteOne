# -*- encoding: utf-8 -*-
# stub: cuprite 0.14.3 ruby lib

Gem::Specification.new do |s|
  s.name = "cuprite".freeze
  s.version = "0.14.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/rubycdp/cuprite/issues", "documentation_uri" => "https://github.com/rubycdp/cuprite/blob/master/README.md", "homepage_uri" => "https://cuprite.rubycdp.com/", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/rubycdp/cuprite" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Dmitry Vorotilin".freeze]
  s.date = "2022-11-12"
  s.description = "Cuprite is a driver for Capybara that allows you to run your tests on a headless Chrome browser".freeze
  s.email = ["d.vorotilin@gmail.com".freeze]
  s.homepage = "https://github.com/rubycdp/cuprite".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Headless Chrome driver for Capybara".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<capybara>.freeze, ["~> 3.0"])
  s.add_runtime_dependency(%q<ferrum>.freeze, ["~> 0.13.0"])
  s.add_development_dependency(%q<byebug>.freeze, ["~> 11.1"])
  s.add_development_dependency(%q<chunky_png>.freeze, ["~> 1.4"])
  s.add_development_dependency(%q<image_size>.freeze, ["~> 3.0"])
  s.add_development_dependency(%q<launchy>.freeze, ["~> 2.5"])
  s.add_development_dependency(%q<pdf-reader>.freeze, ["~> 2.5"])
  s.add_development_dependency(%q<puma>.freeze, ["~> 4.3"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.10"])
  s.add_development_dependency(%q<sinatra>.freeze, ["~> 2.1"])
end
