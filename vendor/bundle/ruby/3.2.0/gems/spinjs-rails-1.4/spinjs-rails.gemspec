# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spinjs-rails/version"

Gem::Specification.new do |s|
  s.name        = "spinjs-rails"
  s.version     = Spinjs::Rails::VERSION
  s.license     = "MIT"
  s.authors     = ["Dmytrii Nagirniak"]
  s.email       = ["dnagir@gmail.com"]
  s.homepage    = "https://github.com/dnagir/spinjs-rails"
  s.summary     = %q{A spinning activity indicator for Rails 3 with no images and CSS.}
  s.description = %q{An animated CSS3 loading spinner with VML fallback for IE.}

  s.rubyforge_project = "spinjs-rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rails", ">= 3.1"
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
