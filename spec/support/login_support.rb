module LoginSupport
  def sign_in_as(user)
  	visit "/"
  	click_link "ログイン"
  	fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password	
    click_button "ログイン"
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end