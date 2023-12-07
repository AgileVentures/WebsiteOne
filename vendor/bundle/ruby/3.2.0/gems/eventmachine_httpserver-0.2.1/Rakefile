# $Id: Rakefile 3546 2006-12-31 21:01:27Z francis $

require 'rake/gempackagetask'
require 'rake/clean'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs += %w(ext)
  t.test_files = FileList['test/test_*.rb']
  t.verbose = true
end

namespace :build do
  sources = FileList['ext/*.{cpp,c,h}']

  file 'ext/Makefile' => 'ext/extconf.rb' do
    Dir.chdir 'ext' do
      ruby 'extconf.rb'
    end
  end
  CLEAN.include('ext/Makefile')
  CLEAN.include('ext/*.log')
  
  libfile = "ext/eventmachine_httpserver.#{Config::CONFIG['DLEXT']}"
  file libfile => ['ext/Makefile', *sources] do
    Dir.chdir 'ext' do
      make = case RUBY_PLATFORM
      when /mswin32/
        'nmake'
      else
        # typical gcc stack, might need a case for gmake on some
        'make'
      end
      sh make
    end
  end
  CLEAN.include(libfile)
  
  task :makefile => 'ext/Makefile'
  
  task :extension => libfile
end

desc "Build the extension inside the ext dir"
task :build => :"build:extension"

desc "Build as necessary, then run tests"
task :test => :build

namespace :gem do
  # TODO : use rake-compiler (github.com/luislavena/rake-compiler) for this!
  # specbinary = eval(File.read("eventmachine_httpserver-binary.gemspec"))
  # specbinary.version = $version
  # desc "Build a binary RubyGem for EventMachine HTTP Server"
  # task :gembinary => ["pkg/eventmachine_httpserver-binary-#{$version}.gem"]
  # Rake::GemPackageTask.new(specbinary)

  def gemspec
    # The template executes some ruby code to make a manifest, so we just eval 
    # it. Later you could fill it with an ERB processor or whatever. It must 
    # return a valid gemspec object.
    @gemspec ||= eval(File.read("eventmachine_httpserver.gemspec.tmpl"))
  end

  def version
    gemspec.version
  end

  file "eventmachine_httpserver.gemspec" => 'eventmachine_httpserver.gemspec.tmpl' do |t|
    open(t.name, 'w') { |f| f.write gemspec.to_ruby }
  end

  desc "Generate the gemspec from template"
  task :spec => "eventmachine_httpserver.gemspec"

  file "eventmachine_httpserver-#{version}.gem" => :"gem:spec" do
    sh "gem build eventmachine_httpserver.gemspec"
  end

  desc "Build the RubyGem for EventMachine HTTP Server"
  task :build => "eventmachine_httpserver-#{version}.gem"

  desc "run gem install on the built gem"
  task :install => :build do
    sh 'gem inst eventmachine_httpserver*.gem'
  end

  CLOBBER.include("eventmachine_httpserver.gemspec")
  CLEAN.include("eventmachine_httpserver-#{version}.gem")
end

task :default => :test