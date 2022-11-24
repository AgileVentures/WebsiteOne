# frozen_string_literal: true

# NOTE: must be called `:selenium` not `:chrome_headless` for screenshots
Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    # It's the `headless` arg that make Chrome headless
    # + you also need the `disable-gpu` arg due to a bug
    args: %w[headless disable-gpu window-size=1366,768]
  )

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Capybara.default_driver = :selenium

Capybara.save_path = 'tmp/capybara'

Capybara.asset_host = 'http://localhost:3000'
