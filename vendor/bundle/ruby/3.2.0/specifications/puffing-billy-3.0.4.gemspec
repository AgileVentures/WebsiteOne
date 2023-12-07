# -*- encoding: utf-8 -*-
# stub: puffing-billy 3.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "puffing-billy".freeze
  s.version = "3.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Olly Smith".freeze]
  s.date = "2022-08-07"
  s.description = "A stubbing proxy server for ruby. Connect it to your browser in integration tests to fake interactions with remote HTTP(S) servers.".freeze
  s.email = ["olly.smith@gmail.com".freeze]
  s.homepage = "https://github.com/oesmith/puffing-billy".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Easy request stubs for browser tests.".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  s.add_development_dependency(%q<thin>.freeze, [">= 0"])
  s.add_development_dependency(%q<faraday>.freeze, [">= 0.9.0"])
  s.add_development_dependency(%q<apparition>.freeze, [">= 0"])
  s.add_development_dependency(%q<capybara>.freeze, [">= 0"])
  s.add_development_dependency(%q<selenium-webdriver>.freeze, [">= 4.0.0"])
  s.add_development_dependency(%q<rack>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<guard>.freeze, [">= 0"])
  s.add_development_dependency(%q<rb-inotify>.freeze, [">= 0"])
  s.add_development_dependency(%q<pry>.freeze, [">= 0"])
  s.add_development_dependency(%q<cucumber>.freeze, [">= 0"])
  s.add_development_dependency(%q<watir>.freeze, ["~> 7.1.0"])
  s.add_development_dependency(%q<webdrivers>.freeze, [">= 5.0.0"])
  s.add_development_dependency(%q<webrick>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<addressable>.freeze, ["~> 2.5"])
  s.add_runtime_dependency(%q<eventmachine>.freeze, ["~> 1.2"])
  s.add_runtime_dependency(%q<em-synchrony>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<em-http-request>.freeze, ["~> 1.1", ">= 1.1.0"])
  s.add_runtime_dependency(%q<eventmachine_httpserver>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<http_parser.rb>.freeze, ["~> 0.6.0"])
  s.add_runtime_dependency(%q<multi_json>.freeze, [">= 0"])
end
