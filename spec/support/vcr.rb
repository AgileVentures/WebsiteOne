VCR.configure do |c|
  #c.allow_http_connections_when_no_cassette = true
  c.configure_rspec_metadata! # https://gist.github.com/kincorvia/4540489
  c.cassette_library_dir = Rails.root.join('spec', 'fixtures', 'cassettes')
  c.hook_into :webmock
end
