test_options = {
    phantomjs_options: [
        '--ignore-ssl-errors=yes',
        "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}"
    ],
    phantomjs: Phantomjs.path,
    js_errors: true,
}

plain_options = {
    phantomjs_options: [
        '--ignore-ssl-errors=yes'
    ],
    phantomjs: Phantomjs.path,
    js_errors: true,
}

debug_options = {
    phantomjs_options: [
        '--ignore-ssl-errors=yes',
    ],
    phantomjs: Phantomjs.path,
    inspector: true,
    debug: true,
    js_errors: true,
}

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    js_errors: false,
    phantomjs: Phantomjs.path,
    phantomjs_options: ['--ssl-protocol=any', '--ignore-ssl-errors=no']
  )
end

Capybara.register_driver :poltergeist_billy do |app|
  Capybara::Poltergeist::Driver.new(app, test_options)
end

Capybara.default_max_wait_time = 10

Capybara.javascript_driver = :poltergeist_billy

Capybara.save_path = 'tmp/capybara'

Capybara.asset_host = 'http://localhost:3000'
