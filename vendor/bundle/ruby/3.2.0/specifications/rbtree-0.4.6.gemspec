# -*- encoding: utf-8 -*-
# stub: rbtree 0.4.6 ruby lib
# stub: extconf.rb

Gem::Specification.new do |s|
  s.name = "rbtree".freeze
  s.version = "0.4.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["OZAWA Takuma".freeze]
  s.date = "2022-12-10"
  s.description = "A RBTree is a sorted associative collection that is implemented with a\nRed-Black Tree. It maps keys to values like a Hash, but maintains its\nelements in ascending key order. The interface is the almost identical\nto that of Hash.\n".freeze
  s.extensions = ["extconf.rb".freeze]
  s.extra_rdoc_files = ["README".freeze, "rbtree.c".freeze]
  s.files = ["README".freeze, "extconf.rb".freeze, "rbtree.c".freeze]
  s.homepage = "http://rbtree.rubyforge.org/".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--title".freeze, "Ruby/RBTree".freeze, "--main".freeze, "README".freeze, "--exclude".freeze, "\\A(?!README|rbtree\\.c).*\\z".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6".freeze)
  s.rubygems_version = "3.4.6".freeze
  s.summary = "A sorted associative collection.".freeze

  s.installed_by_version = "3.4.6" if s.respond_to? :installed_by_version
end
