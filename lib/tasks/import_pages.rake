# frozen_string_literal: true

namespace :db do
  desc 'Import Existing Static Pages into the database'
  task import_pages: :environment do
    # Creating Root Pages
    Dir.entries(Rails.root.join('app', 'views', 'pages').to_s).select { |f| f.ends_with? '.html.erb' }.each do |page|
      StaticPage.create!(title: get_title(page), body: File.open(Rails.root.join('app', 'views', 'pages', page).to_s).read,
                         slug: page.gsub('.html.erb', ''))
      puts "Created Static Page: #{get_title(page)}"
    end

    # Creating remote-pair-programming
    parent1 = StaticPage.find_by_slug('remote-pair-programming')
    Dir.entries(Rails.root.join('app', 'views', 'pages', 'remote-pair-programming').to_s).select do |f|
      f.ends_with? '.html.erb'
    end.each do |page|
      StaticPage.create!(title: get_title(page),
                         body: File.open(Rails.root.join('app', 'views', 'pages', 'remote-pair-programming', page).to_s).read, parent_id: parent1.id)
      puts "Created Static Page: Remote Pair Programming/#{get_title(page)}"
    end

    # Creating pair-programming-protocols
    parent2 = StaticPage.find_by_slug('pair-programming-protocols')
    Dir.entries(Rails.root.join('app', 'views', 'pages', 'remote-pair-programming',
                                'pair-programming-protocols').to_s).select do |f|
      f.ends_with? '.html.erb'
    end.each do |page|
      StaticPage.create!(title: get_title(page),
                         body: File.open(Rails.root.join('app', 'views', 'pages', 'remote-pair-programming', 'pair-programming-protocols', page).to_s).read, parent_id: parent2.id)
      puts "Created Static Page: Remote Pair Programming/Pair Programming Protocols/#{get_title(page)}"
    end
  end
end

def get_title(page)
  page.gsub('.html.erb', '').gsub(/[-_]/, ' ').split.map(&:capitalize).join(' ')
end
