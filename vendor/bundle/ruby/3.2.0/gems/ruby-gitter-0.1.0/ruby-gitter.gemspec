# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitter/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-gitter"
  spec.version       = Gitter::VERSION
  spec.authors       = ["kristenmills"]
  spec.email         = ["kristen@kristen-mills.com"]
  spec.summary       = "Ruby Gitter API Client"
  spec.description   = "Ruby Gitter API Client"
  spec.homepage      = "https://github.com/kristenmills/ruby-gitter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "httparty"
  spec.add_runtime_dependency "hashie"
end
