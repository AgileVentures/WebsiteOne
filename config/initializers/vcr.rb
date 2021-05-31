# frozen_string_literal: true

if Rails.env == 'test'
  VCR.configure do |c|
    c.ignore_localhost = true
    c.default_cassette_options = { record: :new_episodes }
    c.allow_http_connections_when_no_cassette = true
    c.configure_rspec_metadata! unless ENV['CUCUMBER']
    c.cassette_library_dir = Rails.root.join('spec', 'fixtures', 'cassettes')
    c.hook_into :webmock
    c.filter_sensitive_data('twitter consumer key') { Settings.twitter.consumer_key }
    c.filter_sensitive_data('twitter consumer secret') { Settings.twitter.consumer_secret }
    c.filter_sensitive_data('twitter access token') { Settings.twitter.access_token }
    c.filter_sensitive_data('twitter access token secret') { Settings.twitter.access_token_secret }
  end
end
