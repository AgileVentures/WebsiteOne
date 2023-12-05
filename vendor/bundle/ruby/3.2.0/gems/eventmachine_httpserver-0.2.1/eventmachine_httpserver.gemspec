# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{eventmachine_httpserver}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Francis Cianfrocca"]
  s.cert_chain = nil
  s.date = %q{2007-03-16}
  s.description = %q{}
  s.email = %q{garbagecat10@gmail.com}
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["docs/COPYING", "docs/README", "docs/RELEASE_NOTES"]
  s.files = ["README", "Rakefile", "docs/COPYING", "docs/README", "docs/RELEASE_NOTES", "eventmachine_httpserver.gemspec", "eventmachine_httpserver.gemspec.tmpl", "ext/extconf.rb", "ext/http.cpp", "ext/http.h", "ext/rubyhttp.cpp", "lib/evma_httpserver.rb", "lib/evma_httpserver/response.rb", "test/test_app.rb", "test/test_delegated.rb", "test/test_response.rb"]
  s.homepage = %q{https://github.com/eventmachine/evma_httpserver}
  s.rdoc_options = ["--title", "EventMachine_HttpServer", "--main", "docs/README", "--line-numbers"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{EventMachine HTTP Server}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
