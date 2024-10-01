module SystemHelper
  def login_as(user)
    visit root_path
    click_on 'ログイン', match: :first

    within('form[action="/login"]') do
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'password'
      click_on 'ログイン'
    end

    expect(page).to have_current_path(root_path, ignore_query: true)
  end
end

RSpec.configure do |config|
  config.include SystemHelper, type: :system
end
