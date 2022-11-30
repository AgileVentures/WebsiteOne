# frozen_string_literal: true

# NOTE: must be called `:selenium` not `:chrome_headless` for screenshots
Capybara.register_driver :selenium do |app|

  Capybara::Selenium::Driver.load_selenium
  browser_options = ::Selenium::WebDriver::Firefox::Options.new(
    args: %w[headless]
  )
  #browser_options = ::Selenium::WebDriver::Firefox::Options.new
  #browser_options.args << '-headless'
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: browser_options)
  
  #options = Selenium::WebDriver::Chrome::Options.new(
  #  args: %w[headless disable-gpu window-size=1366,768]
  #)
  #options.add_argument("--proxy-server=#{Billy.proxy.host}:#{Billy.proxy.port}")
  #options.add_argument('--proxy-bypass-list=127.0.0.1;localhost')
  #options.add_argument('allow-insecure-localhost')  # Ignore TLS/SSL errors on localhost  options.add_argument('ignore-certificate-errors') # Ignore certificate related errors

  # Capybara::Selenium::Driver.new(
  #   app,
  #   browser: :chrome,
  #   options: options
  # )
end

Capybara.default_driver = :selenium

Capybara.save_path = 'tmp/capybara'

Capybara.asset_host = 'http://localhost:3000'
