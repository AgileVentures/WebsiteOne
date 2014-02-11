# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

old_project_count = Project.count
old_doc_count = Document.count
old_user_count = User.count

puts 'Would you like to ' + 'delete'.red.bold + ' all the existing projects and documents from the database?'

while true
  puts 'yes(y)/no(n):'
  response = STDIN.gets.downcase.chomp
  if response == 'y' or response == 'yes'
    puts 'Clearing existing projects and documents'
    [Project, Document, User].each(&:destroy_all)

    pw = 'randomrandom'
    u = User.create(first_name: 'Random', last_name: 'Guy', email: 'random@random.com', password: pw)
    puts 'Added default user with email: ' + u.email.bold.blue + ' and password: ' + pw.bold.red

    u.projects.create! :title => 'Autograder',
                       :description => 'Autograder for the EdX CS169.x SaaS course',
                       :status => 'Active'

    u.projects.create! :title => 'WebsiteOne',
                       :description => 'The AgileVentures site - a platform for online collaboration and crowdsourced project development.',
                       :status => 'Active'

    u.projects.create! :title => 'LocalSupport',
                       :description => 'The open source project Local Support is a directory of local charity and non-profit organisations for a small geographical area.
Our customer is the non-profit organization Voluntary Action Harrow.
The mission is to support members of the public searching for support groups for things like helping care for an elderly or sick relative; and also to help charities and non-profits find each other and network.',
                       :status => 'Active'

    u.projects.create! :title => 'EduChat',
                       :description => 'Supporting real time synchronous chat in online classes',
                       :status => 'Active'

    u.projects.create! :title => 'PP Scheduler',
                       :description => "Problem: Lots of people want to pair, but they don't know when each other are available
Solution: is something that requires absolutely minimal effort on their part to use in order to let them pair",
                       :status => 'Active'

    u.projects.create! :title => 'Funniest Computer Ever',
                       :description => "Can YOU write a program to make humans laugh? Get your editors fired up and your coding caps ready because you've arrived at the Funniest Computer Ever competition!",
                       :status => 'Active'

    puts 'Created default projects'
    break
  elsif response == 'n' or response == 'no'
    break
  end
end

for i in (1..3)
  p = u.projects.create title: Faker::Lorem.words(3).join(' '), description: Faker::Lorem.paragraph, status: 'active', created_at: 1.month.ago
  for j in (1..3)
    d = p.documents.create title: Faker::Lorem.words(3).join(' '), body: Faker::Lorem.paragraph, created_at: 1.month.ago, user_id: p.user_id
    for k in (1..rand(3))
      d.children.create title: Faker::Lorem.words(3).join(' '), body: Faker::Lorem.paragraph, project_id: p.id, created_at: 1.month.ago, user_id: p.user_id
    end
  end
end

for i in (1..5)
  u = User.create first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, password: Faker::Lorem.characters(10)
  Project.all.sample(3).each do |p|
    u.follow p
  end
end

puts 'Project.count ' + old_project_count.to_s.bold.red + ' -> ' + Project.count.to_s.bold.green
puts 'Document.count ' + old_doc_count.to_s.bold.red + ' -> ' + Document.count.to_s.bold.green
puts 'User.count ' + old_user_count.to_s.bold.red + ' -> ' + User.count.to_s.bold.green
