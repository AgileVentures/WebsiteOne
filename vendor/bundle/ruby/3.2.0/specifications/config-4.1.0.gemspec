# -*- encoding: utf-8 -*-
# stub: config 4.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "config".freeze
  s.version = "4.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Piotr Kuczynski".freeze, "Fred Wu".freeze, "Jacques Crocker".freeze]
  s.date = "2022-11-11"
  s.description = "Easiest way to manage multi-environment settings in any ruby project or framework: Rails, Sinatra, Pandrino and others".freeze
  s.email = ["piotr.kuczynski@gmail.com".freeze, "ifredwu@gmail.com".freeze, "railsjedi@gmail.com".freeze]
  s.extra_rdoc_files = ["README.md".freeze, "CHANGELOG.md".freeze, "CONTRIBUTING.md".freeze, "LICENSE.md".freeze]
  s.files = ["CHANGELOG.md".freeze, "CONTRIBUTING.md".freeze, "LICENSE.md".freeze, "README.md".freeze]
  s.homepage = "https://github.com/rubyconfig/config".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "\n\e[33mThanks for installing Config\e[0m\nPlease consider donating to our open collective to help us maintain this project.\n\n\nDonate: \e[34mhttps://opencollective.com/rubyconfig/donate\e[0m\n".freeze
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.4.6".freeze
  s.summary = "Effortless multi-environment settings in Rails, Sinatra, Pandrino and others".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<deep_merge>.freeze, ["~> 1.2", ">= 1.2.1"])
  s.add_runtime_dependency(%q<dry-validation>.freeze, ["~> 1.0", ">= 1.0.0"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 12.0", ">= 12.0.0"])
  s.add_development_dependency(%q<appraisal>.freeze, ["~> 2.3", ">= 2.3.0"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.9", ">= 3.9.0"])
  s.add_development_dependency(%q<bootsnap>.freeze, [">= 1.4.4"])
  s.add_development_dependency(%q<rails>.freeze, ["= 6.1.4"])
  s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 5.0"])
  s.add_development_dependency(%q<psych>.freeze, [">= 4"])
  s.add_development_dependency(%q<mdl>.freeze, ["~> 0.9", ">= 0.9.0"])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.85.0"])
end
