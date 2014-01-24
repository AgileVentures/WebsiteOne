# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

old_project_count = Project.count
old_doc_count = Document.count

puts 'Would you like to clear the existing projects and documents from the database?'
while true
  puts 'yes(y) or no(n):'
  response = STDIN.gets.downcase.chomp
  if response == 'y' or response == 'yes'
    puts 'Clearing existing projects and documents'
    [Project, Document].each(&:destroy_all)
    pf = Project.create({ title: 'WebsiteOne', description: 'The vision for the future', status: 'inactive' })
    pf.documents.create({ title: 'Project Structure', body: '<h2>How things should be done</h2><blockquote>Just do it</blockquote>' })
    pf.documents.create({ title: 'Wiki', body: '<h2>The Project Wiki</h2>empty' })
    break
  elsif response == 'n' or response == 'no'
    break
  end
end

for i in (1..3)
  p = Project.create({ title: Faker::Name.name, description: Faker::Lorem.paragraph, status: 'active' })
  for j in (1..2)
    p.documents.create({ title: Faker::Name.title, body: Faker::Lorem.paragraph })
  end
end

puts 'Project.count ' + old_project_count.to_s + ' -> ' + Project.count.to_s
puts 'Document.count ' + old_doc_count.to_s + ' -> ' + Document.count.to_s
