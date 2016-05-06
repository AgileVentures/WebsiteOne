Capybara.javascript_driver = :poltergeist_billy

Capybara.default_max_wait_time = 10

test_options = {
    phantomjs_options: [
        '--ignore-ssl-errors=yes',
        "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}"
    ],
    phantomjs: Phantomjs.path,
    js_errors: true,
}

Capybara.register_driver :poltergeist_billy do |app|
  Capybara::Poltergeist::Driver.new(app, test_options)
end

debug_options = {
    phantomjs_options: [
        '--ignore-ssl-errors=yes',
        "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}"
    ],
    phantomjs: Phantomjs.path,
    inspector: true,
    js_errors: true,
}
