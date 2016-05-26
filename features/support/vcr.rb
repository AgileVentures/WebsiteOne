require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'features/support/fixtures/cassettes'
  c.ignore_localhost = true
  c.default_cassette_options = {
      :match_requests_on => [
          :method,
          VCR.request_matchers.uri_without_param(:imp, :prev_imp)
      ]
  }
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', :use_scenario_name => true
end
