# -*- encoding: utf-8 -*-
# stub: paypal-sdk-rest 1.7.4 ruby lib

Gem::Specification.new do |s|
  s.name = "paypal-sdk-rest".freeze
  s.version = "1.7.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["PayPal".freeze]
  s.date = "2020-01-17"
  s.description = "The PayPal REST SDK provides Ruby APIs to create, process and manage payment.".freeze
  s.email = ["DL-PP-RUBY-SDK@paypal.com".freeze]
  s.homepage = "https://developer.paypal.com".freeze
  s.licenses = ["PayPal SDK License".freeze]
  s.rubygems_version = "3.4.6".freeze
  s.summary = "The PayPal REST SDK provides Ruby APIs to create, process and manage payment.".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<coveralls>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<xml-simple>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<multi_json>.freeze, ["~> 1.0"])
end
