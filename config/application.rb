require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Bundler.require(:default, Rails.env)

module WebsiteOne
  class Application < Rails::Application
    # necessary to make Settings available
    Config::Integrations::Rails::Railtie.preload

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.exceptions_app = self.routes

    config.action_mailer.delivery_method = Settings.mailer.delivery_method.to_sym
    config.action_mailer.smtp_settings = Settings.mailer.smtp_settings.to_hash
    config.action_mailer.default_url_options = { host: Settings.mailer.url_host }

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    #config.time_zone = 'Central Time (US & Canada)'
    ENV['TZ'] = 'UTC'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    I18n.enforce_available_locales = false

    config.assets.enabled = true

    # Precompile additional assets.
    # application.js, application.css.scss, and all non-JS/CSS in app/assets folder are already added.
    config.assets.precompile += %w(
      404.js projects.js events.js google-analytics.js
      disqus.js event_instances.js scrums.js
    )

    config.autoload_paths += Dir[Rails.root.join('app', '**/')]
  end
end
