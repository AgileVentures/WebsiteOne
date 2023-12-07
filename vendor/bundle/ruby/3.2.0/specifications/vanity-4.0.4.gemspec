# -*- encoding: utf-8 -*-
# stub: vanity 4.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "vanity".freeze
  s.version = "4.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Assaf Arkin".freeze]
  s.date = "2022-11-28"
  s.description = "Mirror, mirror on the wall ...".freeze
  s.email = "assaf@labnotes.org".freeze
  s.executables = ["vanity".freeze]
  s.extra_rdoc_files = ["README.md".freeze, "CHANGELOG".freeze]
  s.files = ["CHANGELOG".freeze, "README.md".freeze, "bin/vanity".freeze]
  s.homepage = "http://vanity.labnotes.org".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "To get started run vanity --help".freeze
  s.rdoc_options = ["--title".freeze, "Vanity 4.0.4".freeze, "--main".freeze, "README.md".freeze, "--webcvs".freeze, "http://github.com/assaf/vanity".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5".freeze)
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Experience Driven Development framework for Ruby".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<i18n>.freeze, [">= 0"])
  s.add_development_dependency(%q<appraisal>.freeze, ["~> 2.0"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 1.8.0"])
  s.add_development_dependency(%q<fakefs>.freeze, [">= 0"])
  s.add_development_dependency(%q<minitest>.freeze, [">= 4.2"])
  s.add_development_dependency(%q<pry>.freeze, [">= 0"])
  s.add_development_dependency(%q<timecop>.freeze, [">= 0"])
  s.add_development_dependency(%q<webmock>.freeze, [">= 0"])
end
