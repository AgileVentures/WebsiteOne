if Rails.env == 'test'
  VCR.configure do |c|
    c.ignore_localhost = true
    c.default_cassette_options = {record: :once, match_requests_on: [:host]}
    #c.allow_http_connections_when_no_cassette = true
    c.configure_rspec_metadata! unless ENV['CUCUMBER']
    c.cassette_library_dir = Rails.root.join('fixtures', 'cassettes')
    c.hook_into :webmock
  end
end
