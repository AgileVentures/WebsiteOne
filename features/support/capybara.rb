Capybara.javascript_driver = :poltergeist_billy

Capybara.default_max_wait_time = 10

test_options = {
    phantomjs_options: ['--ignore-ssl-errors=yes', "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}"],
    phantomjs: Phantomjs.path
}

Capybara.register_driver :poltergeist_billy do |app|
  Capybara::Poltergeist::Driver.new(app, test_options)
end
