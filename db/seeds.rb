# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

klasses = [ Project, Document, User, Article, Event ]
old_counts = klasses.map(&:count)
should_prompt = old_counts.min > 0

def get_country
  country = File.readlines(Rails.root + 'spec/fixtures/country_codes.txt').sample
  code, name = country.chomp.split('|')
  @country = {country_name: name, country_code: code}
end

if should_prompt
  puts 'Would you like to ' + 'delete'.red.bold + ' all the existing projects and documents from the database?'
end

while true
  if should_prompt
    print 'yes(y)/no(n): '
    response = STDIN.gets.downcase.chomp
  else
    response = 'y'
  end

  if response == 'y' || response == 'yes'
    puts 'Clearing existing projects and documents'
    klasses.each(&:delete_all)

    pw = 'randomrandom'
    u = User.create(first_name: 'Random', last_name: 'Guy', email: 'random@random.com', password: pw)
    puts 'Added default user with email: ' + u.email.bold.blue + ' and password: ' + pw.bold.red

    autograder = u.projects.create! :title => 'Autograder',
                       :description => 'Autograder for the EdX CS169.x SaaS course',
                       :status => 'Active',
                       commit_count: 200
    autograder.source_repositories.create!(url: 'https://github.com/saasbook/rag')

    websiteone = u.projects.create! :title => 'WebsiteOne',
                       :description => 'The AgileVentures site - a platform for online collaboration and crowdsourced project development.',
                       :status => 'Active',
                       commit_count: 190
    websiteone.source_repositories.create!(url: 'https://github.com/AgileVentures/WebsiteOne')

    localsupport = u.projects.create! :title => 'LocalSupport',
                       :description => 'The open source project Local Support is a directory of local charity and non-profit organisations for a small geographical area.
Our customer is the non-profit organization Voluntary Action Harrow.
The mission is to support members of the public searching for support groups for things like helping care for an elderly or sick relative; and also to help charities and non-profits find each other and network.',
                       :status => 'Active',
                       commit_count: 100
    localsupport.source_repositories.create!(url: 'https://github.com/AgileVentures/LocalSupport')

    u.projects.create! :title => 'EduChat',
                       :description => 'Supporting real time synchronous chat in online classes',
                       :status => 'Inactive',
                       commit_count: 100

    u.projects.create! :title => 'PP Scheduler',
                       :description => "Problem: Lots of people want to pair, but they don't know when each other are available
Solution: is something that requires absolutely minimal effort on their part to use in order to let them pair",
                       :status => 'Active'

    u.projects.create! :title => 'Funniest Computer Ever',
                       :description => "Can YOU write a program to make humans laugh? Get your editors fired up and your coding caps ready because you've arrived at the Funniest Computer Ever competition!",
                       :status => 'Active'

    puts 'Created default projects'
    break
  elsif response == 'n' || response == 'no'
    break
  end
end

u ||= User.last
for i in (1..3)
  p = u.projects.create title: Faker::Lorem.words(3).join(' '), description: Faker::Lorem.paragraph, status: 'active', created_at: 1.month.ago
  for j in (1..3)
    d = p.documents.create title: Faker::Lorem.words(3).join(' '), body: Faker::Lorem.paragraph, created_at: 1.month.ago, user_id: p.user_id
    for k in (1..rand(3))
      d.children.create title: Faker::Lorem.words(3).join(' '), body: Faker::Lorem.paragraph, project_id: p.id, created_at: 1.month.ago, user_id: p.user_id
    end
  end
end

for i in (1..300)
  get_country
  u = User.create first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, password: Faker::Lorem.characters(10), country_name: @country[:country_name], country_code: @country[:country_code]
  Project.all.sample(3).each do |p|
    u.follow p
  end
end

for i in (1..4)
  User.all.sample(3).each do |u|
    u.articles.create!(title: Faker::Lorem.words(3).join(' '), content: Faker::Lorem.paragraphs(3).join('\n'))
  end
end


Event.create!( name: 'Seeded event',
               category: 'Scrum',
               description: 'Seeded content',
               # event_date: 'Mon, 17 Jun 2013',
               # start_time: '2000-01-01 09:00:00 UTC',
               # end_time: '2000-01-01 17:00:00 UTC',
               start_datetime: 'Mon, 17 Jun 2014',
               duration: 600,
               repeats: 'weekly',
               repeats_every_n_weeks: '1',
               repeats_weekly_each_days_of_the_week_mask: '31',
               repeat_ends: 'never',
               repeat_ends_on: 'Mon, 17 Jun 2015',
               time_zone: 'UTC')

Event.create!( name: 'evening event',
               category: 'Scrum',
               description: 'Seeded content',
               # event_date: 'Mon, 17 Jun 2013',
               # start_time: '2000-01-01 09:00:00 UTC',
               # end_time: '2000-01-01 17:00:00 UTC',
               start_datetime: 'Mon, 17 Jun 2014 17:00:00 UTC',
               duration: 600,
               repeats: 'weekly',
               repeats_every_n_weeks: '1',
               repeats_weekly_each_days_of_the_week_mask: '31',
               repeat_ends: 'never',
               repeat_ends_on: 'Mon, 17 Jun 2015',
               time_zone: 'UTC')

event = Event.find_by(name: 'evening event')
project = Project.find_by(title: localsupport.title)

10.times do
  EventInstance.create(event: event, project: project, yt_video_id: 'QWERT55')
end

if StaticPage.count == 0
  Rake::Task['db:import_pages'].invoke
end

# Create ghost user
Rake::Task['user:create_anonymous'].invoke

klasses.each_with_index do |klass, i|
  puts "#{klass.name}.count " + old_counts[i].to_s.bold.red + ' -> ' + klass.count.to_s.bold.green
end
