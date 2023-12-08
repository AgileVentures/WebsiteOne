require 'aruba/cucumber'

module ArubaExt
  def run(cmd)
    super(cmd =~ /^rspec/ ? "bin/#{cmd}" : cmd)
  end
end

World(ArubaExt)

Before do
  @aruba_timeout_seconds = 30
end

unless File.directory?('./tmp/sample')
  system "rake generate:sample"
end

def aruba_path(file_or_dir)
  File.expand_path("../../../#{file_or_dir.sub('sample','aruba')}", __FILE__)
end

def sample_path(file_or_dir)
  File.expand_path("../../../#{file_or_dir}", __FILE__)
end

def write_symlink(file_or_dir)
  source = sample_path(file_or_dir)
  target = aruba_path(file_or_dir)
  system "ln -s #{source} #{target}"
end

def copy(file_or_dir)
  source = sample_path(file_or_dir)
  target = aruba_path(file_or_dir)
  system "cp -r #{source} #{target}"
end

Before do
  steps %Q{
    Given a directory named "spec"
  }

  Dir['tmp/sample/*'].each do |file_or_dir|
    if !(file_or_dir =~ /spec$/)
      write_symlink(file_or_dir)
    end
  end

  ["spec/spec_helper.rb"].each do |file_or_dir|
    write_symlink("tmp/sample/#{file_or_dir}")
  end
end
