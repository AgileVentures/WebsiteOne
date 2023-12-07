# encoding: UTF-8

require 'rubygems' unless ENV['NO_RUBYGEMS']

require 'bundler'
require 'rubygems/package_task'

Bundler::GemHelper.install_tasks

task :download_maps do
  require 'open-uri'
  # This task scrapes jvectormap.com/maps and downloads them
  # I wish there was a better way to get the map data, but I can't find a repo or anything, so here we are...

  output_dir = File.join(File.dirname(__FILE__), "vendor")
  puts 'Getting list of map urls...'
  home = open('http://jvectormap.com/maps/').read
  links = home.scan(/<a\shref="(\/maps.*)">/).flatten.uniq

  js_files = links.flat_map do |link|
    puts "Getting list of maps for #{link}..."
    content = open(File.join('http://jvectormap.com', link)).read
    content.scan(/<a\shref=\"(\/js\/jquery-jvectormap[\w\d\-]+\.js)">/).flatten.uniq
  end

  js_files.uniq.each do |file|
    puts "Downloading map #{File.basename(file)}..."
    map_data = open(File.join('http://jvectormap.com', file)).read
    save_name = map_data.scan(/jQuery\.fn\.vectorMap\('addMap',\s'([\w_\-]+)'/).flatten.first
    File.open(File.join(output_dir, 'assets/javascripts/jvectormap/maps', "#{save_name}.js"), 'w+') do |f|
      f.write(map_data)
    end
  end

  puts 'Done.'
end

load 'tasks/jvectormap.rake'
