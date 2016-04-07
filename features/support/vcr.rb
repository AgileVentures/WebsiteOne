VCR.configure do |c|
  c.cassette_library_dir = 'features/support/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
  c.ignore_hosts 'codeclimate.com'
end

VCR.cucumber_tags do |t|
  t.tag '@vcr', use_scenario_name: true
  # could mux this to @javascript? or just add @vcr at the top of every feature?
end