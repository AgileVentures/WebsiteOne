# require 'selenium/webdriver'
#
# Capybara.register_driver :chrome do |app|
#   Capybara::Selenium::Driver.new(app, browser: :chrome)
# end
#
# Capybara.register_driver :headless_chrome do |app|
#   capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
#     chromeOptions: { args: %w(headless disable-gpu no-sandbox) }
#   )
#
#   Capybara::Selenium::Driver.new app,
#     browser: :chrome,
#     desired_capabilities: capabilities
# end
#
#
# Capybara.default_driver = :headless_chrome
# Capybara.register_driver :selenium_chrome_billy do |app|
#   Capybara::Selenium::Driver.new(app)
# end

# test_options = {
#     selenium_options: [
#         '--ignore-ssl-errors=yes',
#         "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}"
#     ],
#     phantomjs: Phantomjs.path,
#     js_errors: true,
# }

# Capybara.register_driver :poltergeist do |app|
#   Capybara::Poltergeist::Driver.new(app, js_errors: false,
#                                     phantomjs: Phantomjs.path,
#                                     phantomjs_options: ['--ssl-protocol=tlsv1.2', '--ignore-ssl-errors=yes'])
# end
#
# test_options = {
#     phantomjs_options: [
#         '--ignore-ssl-errors=yes',
#         "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}"
#     ],
#     phantomjs: Phantomjs.path,
#     js_errors: true,
# }
#
# plain_options = {
#     phantomjs_options: [
#         '--ignore-ssl-errors=yes'
#     ],
#     phantomjs: Phantomjs.path,
#     js_errors: true,
# }
#
# debug_options = {
#     phantomjs_options: [
#         '--ignore-ssl-errors=yes',
#     ],
#     phantomjs: Phantomjs.path,
#     inspector: true,
#     debug: true,
#     js_errors: true,
# }
#
# Capybara.register_driver :poltergeist_billy do |app|
#   Capybara::Poltergeist::Driver.new(app, test_options)
# end
#
# Capybara.default_max_wait_time = 5
#
# Capybara.javascript_driver = :poltergeist_billy

# Capybara.save_path = 'tmp/capybara'
#
# Capybara.asset_host = 'http://localhost:3000'
