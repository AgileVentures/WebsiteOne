# -*- encoding: utf-8 -*-
# stub: rack-cache 1.13.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rack-cache".freeze
  s.version = "1.13.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ryan Tomayko".freeze]
  s.date = "2021-09-26"
  s.description = "Rack::Cache is suitable as a quick drop-in component to enable HTTP caching for Rack-based applications that produce freshness (Expires, Cache-Control) and/or validation (Last-Modified, ETag) information.".freeze
  s.email = "r@tomayko.com".freeze
  s.extra_rdoc_files = ["README.md".freeze, "MIT-LICENSE".freeze, "CHANGES".freeze]
  s.files = ["CHANGES".freeze, "MIT-LICENSE".freeze, "README.md".freeze]
  s.homepage = "https://github.com/rtomayko/rack-cache".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--line-numbers".freeze, "--inline-source".freeze, "--title".freeze, "Rack::Cache".freeze, "--main".freeze, "Rack::Cache".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.4.6".freeze
  s.summary = "HTTP Caching for Rack".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<rack>.freeze, [">= 0.4"])
  s.add_development_dependency(%q<maxitest>.freeze, [">= 0"])
  s.add_development_dependency(%q<memcached>.freeze, [">= 0"])
  s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
  s.add_development_dependency(%q<dalli>.freeze, [">= 0"])
  s.add_development_dependency(%q<bump>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
end
