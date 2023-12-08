$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'jvectormap/rails/version'

Gem::Specification.new do |s|
  s.name     = 'jvectormap-rails'
  s.version  = ::JVectorMap::Rails::VERSION
  s.authors  = ['Cameron Dutro', 'Kirill Lebedev']
  s.email    = ['camertron@gmail.com', 'echo.bjornd@gmail.com']
  s.homepage = 'https://github.com/bjornd/jvectormap'

  s.description = s.summary = 'jVectorMap for the Rails asset pipeline'

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'railties', '>= 3.1'

  s.require_path = 'lib'
  s.files = Dir['{lib,vendor,tasks}/**/*', 'Gemfile', 'History.txt', 'LICENSE', 'README.md', 'Rakefile', 'jvectormap-rails.gemspec']
end
