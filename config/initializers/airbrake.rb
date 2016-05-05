if Rails.env.production?
  Airbrake.configure do |c|
    c.project_id = ENV['AIRBRAKE_PROJECT_ID']
    c.project_key = ENV['AIRBRAKE_API_KEY']

    c.root_directory = Rails.root
    c.logger = Rails.logger

    c.environment = Rails.env
    c.ignore_environments = %w(test)

    c.blacklist_keys = [/password/i]
  end
end

# If Airbrake doesn't send any expected exceptions, we suggest to uncomment the
# line below. It might simplify debugging of background Airbrake workers, which
# can silently die.
# Thread.abort_on_exception = ['test', 'development'].include?(Rails.env)
