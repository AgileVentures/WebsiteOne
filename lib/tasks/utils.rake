namespace :util do
  task 'geocode-all' => [ :environment ] do
    User.all.each do |user|
      user.geocode
      user.save!
      puts "Successfully geocoded User:#{user.id}"
    end
  end

  task 'geocode-new' => [ :environment ] do
    User.where(country_name: nil).each do |user|
      user.geocode
      user.save!
      puts "Successfully geocoded User:#{user.id}: #{user.display_name}"
    end
  end
end
