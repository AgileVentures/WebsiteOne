namespace :db do
  desc 'Import Existing Static Pages into the database'
  task :import_pages => :environment do
    Dir.entries(Rails.root.join('app', 'views', 'pages').to_s).select { |f| f.ends_with? ".html.erb" }.each do |page|
      StaticPage.create!(title: get_title(page), body: File.open(Rails.root.join('app', 'views', 'pages', page).to_s).read)
      puts "Created Static Page: #{get_title(page)}"
    end
  end
end


def get_title(page)
  page.gsub(".html.erb", "").gsub("-", " ").split.map(&:capitalize).join(' ')
end