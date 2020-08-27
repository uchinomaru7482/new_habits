require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  scenario "user sign in" do
  	visit "/"
  	click_link "新規登録"
  	fill_in "メールアドレス", with: "example@example.com"
  	fill_in "ニックネーム", with: "example"
  	fill_in "パスワード", with: "aaaaaaaa"
  	fill_in "パスワード確認", with: "aaaaaaaa"
  	click_button "新規登録"

  	expect(page).to have_content "ようこそ！アカウント登録が完了しました。"
  end

  scenario "register a new habit" do
    user = FactoryBot.create(:user)
    
    visit "/"
    click_link "ログイン"
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password	
    click_button "ログイン"

    expect {
      click_link "習慣登録"
      fill_in "習慣名", with: "習慣登録テスト"
      click_button "登録"

      expect(page).to have_content "習慣を登録しました"
      expect(page).to have_content "習慣登録テスト"
    }.to change(user.habits, :count).by(1)
  end
end
