# frozen_string_literal: true

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development? || Rails.env.test?
    ENV['GPLUS_KEY'] = '463111787485-rj34ev5ai9pncbjl0oreqg3gr86jt92j.apps.googleusercontent.com'
    ENV['GPLUS_SECRET'] = 'IR5APLsAJhmP8NPLSkRZan48'

    ENV['GITHUB_KEY'] = 'd05eb310ebf549e53889'
    ENV['GITHUB_SECRET'] = '6a5988af12a8a012399e037d0586bf706c4bfbf0'
  end

  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :google_oauth2, ENV['GPLUS_KEY'], ENV['GPLUS_SECRET'], {
    name: 'gplus',
    setup: lambda { |env|
      if (params = env['rack.session']['omniauth.params']) && params.fetch('youtube', false)
        env['omniauth.strategy'].options[:scope] = 'youtube,userinfo.email'
      end
    }
  }
end
