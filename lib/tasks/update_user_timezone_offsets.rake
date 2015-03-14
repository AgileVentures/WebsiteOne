namespace :db do
  desc "Update every users' timezone offset"
  task :update_timezone_offset => :environment do
    User.all.each do |user|
      ##
      # Force to update the timezone offset...
      # The real update handle this line of code in the user model:
      # 
      #   before_save :generate_timezone_offset
      # 
      # It will be update when the longitude and/or latitude values changed
      # (and exist) or the timezone_offset column is empty
      ##
      user.save
      puts user.display_name.bold.blue + " timezone offset updated"
    end
    puts "Update has been completed".green
  end
end
