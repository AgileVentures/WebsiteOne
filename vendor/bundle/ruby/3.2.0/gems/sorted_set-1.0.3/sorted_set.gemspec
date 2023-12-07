Gem::Specification.new do |spec|
  spec.name          = "sorted_set"
  spec.version       = "1.0.3"
  spec.authors       = ["Akinori MUSHA"]
  spec.email         = ["knu@idaemons.org"]

  spec.summary       = %q{Implements a variant of Set whose elements are sorted in ascending order}
  spec.description   = %q{Implements a variant of Set whose elements are sorted in ascending order}
  spec.homepage      = "https://github.com/knu/sorted_set"
  spec.license       = "BSD-2-Clause"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/knu/sorted_set/blob/v#{spec.version}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if defined?(JRUBY_VERSION)
    spec.platform = "java"
  else
    spec.add_runtime_dependency "set", "~> 1.0"
    spec.add_runtime_dependency "rbtree"
  end
end
