Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('window-size=1680,1050')
  Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV.fetch('SELENIUM_DRIVER_URL', nil), capabilities: options)


  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch('SELENIUM_DRIVER_URL', 'http://chrome:4444/wd/hub'),
    capabilities: options
  )
end

Capybara.default_driver = :remote_chrome
Capybara.javascript_driver = :remote_chrome
Capybara.default_max_wait_time = 5
