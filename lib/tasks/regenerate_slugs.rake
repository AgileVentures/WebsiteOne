namespace :db do
  task :regenerate_slugs => :environment do
    [ Project, User, Document ].each do |klass|
      klass.find_each(&:save)
    end
  end
end