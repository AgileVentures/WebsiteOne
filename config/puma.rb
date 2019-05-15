workers Integer(ENV['PUMA_WORKERS'] || 3)
# threads_count = ENV.fetch("MAX_THREADS")
# threads threads_count, threads_count
threads Integer(ENV['MIN_THREADS']  || 1), Integer(ENV['MAX_THREADS'] || 16)

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # worker specific setup
  ActiveSupport.on_load(:active_record) do
    config = ApplicationRecord.configurations[Rails.env] ||
                Rails.application.config.database_configuration[Rails.env]
    config['pool'] = ENV['MAX_THREADS'] || 16
    ApplicationRecord.establish_connection(config)
  end
end

after_worker_fork do |_server, _worker|
  ActiveRecord::Base.establish_connection
  Vanity.playground.establish_connection unless ENV['SEMAPHORE'] == 'true'
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
