# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "constant-redefinition"
  s.version     = "1.1.0"
  s.authors     = ["David Czarnecki"]
  s.email       = ["me@davidczarnecki.com"]
  s.homepage    = "https://github.com/czarneckid/constant-redefinition"
  s.summary     = %q{Allows you to define constants if not defined on an object and redefine constants without warning}
  s.description = %q{Allows you to define constants if not defined on an object and redefine constants without warning}

  s.rubyforge_project = "constant-redefinition"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
end
