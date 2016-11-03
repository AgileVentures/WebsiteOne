
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false,
                                    phantomjs: Phantomjs.path,
                                    phantomjs_options: ['--ssl-protocol=tlsv1.2', '--ignore-ssl-errors=yes'])
end

# Capybara.javascript_driver = :poltergeist

#
# Capybara.default_max_wait_time = 10
#
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
        "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}"
    ],
    phantomjs: Phantomjs.path,
    inspector: true,
    js_errors: true,
}

Capybara.register_driver :poltergeist_billy do |app|
  Capybara::Poltergeist::Driver.new(app, test_options)
end

# Capybara.register_driver :ignore_ssl_errors do |app|
#   Capybara::Poltergeist::Driver.new(app, plain_options)
# end

Capybara.default_max_wait_time = 20

Capybara.javascript_driver = :poltergeist_billy


Capybara.save_and_open_page_path = 'tmp/capybara'