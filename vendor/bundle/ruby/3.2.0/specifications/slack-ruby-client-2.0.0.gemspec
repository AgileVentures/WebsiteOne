# -*- encoding: utf-8 -*-
# stub: slack-ruby-client 2.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "slack-ruby-client".freeze
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Daniel Doubrovkine".freeze]
  s.date = "2022-10-19"
  s.email = "dblock@dblock.org".freeze
  s.executables = ["slack".freeze]
  s.files = ["bin/slack".freeze]
  s.homepage = "http://github.com/slack-ruby/slack-ruby-client".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7".freeze)
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Slack Web and RealTime API client.".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<faraday>.freeze, [">= 2.0"])
  s.add_runtime_dependency(%q<faraday-mashify>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<faraday-multipart>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<gli>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<hashie>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<websocket-driver>.freeze, [">= 0"])
end
