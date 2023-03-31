# frozen_string_literal: true

Recaptcha.configure do |config|
  config.site_key = ENV.fetch('RECAPTCHA_SITE_KEY', nil)
  config.secret_key = ENV.fetch('RECAPTCHA_SECRET_KEY', nil)
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end
