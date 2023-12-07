namespace :jvectormap do
  task :maps do
    path = File.expand_path(
      File.join(File.dirname(__FILE__), '../vendor/assets/javascripts/jvectormap/maps/**')
    )

    puts Dir.glob(path).map { |file| File.basename(file).gsub(/\.js\z/, '') }.join("\r\n")
  end
end
