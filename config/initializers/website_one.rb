require 'agile_ventures'
require 'youtube_videos'

Dir[File.join(Rails.root, "lib", "core_ext", '**', "*.rb")].each {|l| require l }
Dir[File.join(Rails.root, "lib", "validators", "*.rb")].each {|l| require l }
