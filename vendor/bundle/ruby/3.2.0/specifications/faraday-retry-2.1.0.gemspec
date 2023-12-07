# -*- encoding: utf-8 -*-
# stub: faraday-retry 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "faraday-retry".freeze
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/lostisland/faraday-retry/issues", "changelog_uri" => "https://github.com/lostisland/faraday-retry/blob/v2.1.0/CHANGELOG.md", "documentation_uri" => "http://www.rubydoc.info/gems/faraday-retry/2.1.0", "homepage_uri" => "https://github.com/lostisland/faraday-retry", "source_code_uri" => "https://github.com/lostisland/faraday-retry" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mattia Giuffrida".freeze]
  s.date = "2023-03-03"
  s.description = "Catches exceptions and retries each request a limited number of times.\n".freeze
  s.email = ["giuffrida.mattia@gmail.com".freeze]
  s.homepage = "https://github.com/lostisland/faraday-retry".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new([">= 2.6".freeze, "< 4".freeze])
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Catches exceptions and retries each request a limited number of times".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<faraday>.freeze, ["~> 2.0"])
  s.add_development_dependency(%q<bundler>.freeze, ["~> 2.0"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
  s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.21.0"])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.21.0"])
  s.add_development_dependency(%q<rubocop-packaging>.freeze, ["~> 0.5.0"])
  s.add_development_dependency(%q<rubocop-performance>.freeze, ["~> 1.0"])
  s.add_development_dependency(%q<rubocop-rspec>.freeze, ["~> 2.0"])
end
