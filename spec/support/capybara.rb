Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('window-size=1680,1050')
  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: ENV.fetch('SELENIUM_DRIVER_URL', nil),
    capabilities: options
  )
end

Capybara.default_driver = :remote_chrome
Capybara.javascript_driver = :remote_chrome
Capybara.default_max_wait_time = 8



RSpec.configure do |config|
  # ローカル（Docker）環境 or CI環境で、使うブラウザを変更するための条件文
  if ENV['CODEBUILD_BUILD_ID']
	  # ローカルのDockerコンテナ内ではリモートのブラウザ（chromeコンテナ）を使用する
    config.before(:each, type: :system) do
      driven_by :remote_chrome
      Capybara.server_host = IPSocket.getaddress(Socket.gethostname) # テスト用サーバーのIPアドレスを取得し、リモートChromeがテストサーバーに接続できるようにします。
      Capybara.server_port = 4444 # Capybaraのサーバーが使うポートを固定で設定し、ブラウザが正しいポートに接続できるようにします。
      Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
      Capybara.ignore_hidden_elements = false
    end
  else
	  # GitHub ActionsのCI環境では仮想環境にインストールしたChromeブラウザにヘッドレスモードで接続させる
    config.before(:each, type: :system) do
      driven_by :selenium, using: :headless_chrome, screen_size: [1920, 1080]
    end
  end
end