require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  describe "user" do
	  scenario "user sign up" do
	  	visit "/"
	  	click_link "新規登録"
	  	fill_in "メールアドレス", with: "example@example.com"
	  	fill_in "ニックネーム", with: "example"
	  	fill_in "パスワード", with: "aaaaaaaa"
	  	fill_in "パスワード確認", with: "aaaaaaaa"
	  	click_button "新規登録"

	  	expect(page).to have_content "ようこそ！アカウント登録が完了しました。"
	  end

	  scenario "user sign in" do
	  	user = FactoryBot.create(:user)

	  	visit "/"
	  	click_link "ログイン"
	    fill_in "メールアドレス", with: user.email
	    fill_in "パスワード", with: user.password	
	    click_button "ログイン"

	    expect(page).to have_content "ログインしました。"
	  end
  end

  describe "habit" do
	  scenario "register a check type habit" do
	    user = FactoryBot.create(:user)
	    sign_in_as user

	    expect{
	      click_link "習慣登録"
	      fill_in "習慣名", with: "習慣登録テスト"
	      click_button "登録"

	      expect(page).to have_content "習慣を登録しました"
	      expect(page).to have_content "習慣登録テスト"
	      expect(page).to_not have_content "トータル時間　：0時間"
	    }.to change(user.habits, :count).by(1)
	  end

	  scenario "register a record type habit" do
	    user = FactoryBot.create(:user)
	    sign_in_as user

	    expect{
	      click_link "習慣登録"
	      fill_in "習慣名", with: "習慣登録テスト"
	      choose "habit_record_type_false"
	      click_button "登録"

	      expect(page).to have_content "習慣を登録しました"
	      expect(page).to have_content "習慣登録テスト"
	      expect(page).to have_content "トータル時間　：0時間"
	    }.to change(user.habits, :count).by(1)
	  end

	  scenario "remove a habit" do
	  	user = FactoryBot.create(:user)
	  	habit = FactoryBot.create(:habit, owner: user)
	  	post = FactoryBot.create(:post, habit: habit)
	  	sign_in_as user
	  	click_link "プロフィール"
	  	within ".habit" do
	  		click_link "削除"
	  	end

	  	expect(user.habits).to be_empty
	  	expect(habit.posts).to be_empty
	  end
	end

	describe "post" do
	  scenario "post achievements with check" do
	  	user = FactoryBot.create(:user)
	  	habit = FactoryBot.create(:habit, record_type: true, owner: user)
	  	sign_in_as user

	    expect{
	      click_link "今日の成果を投稿"
	      fill_in "今日の成果", with: "テストを行った"
	      check "post[check]"
	      click_button "投稿"

	      expect(page).to have_content "テストを行った"
	      expect(page).to have_content "継続日数　　　：1日"
	      expect(page).to have_content "トータル日数　：1日"
	    }.to change(habit.posts, :count).by(1)
	  end

	  scenario "post achievements without check" do
	  	user = FactoryBot.create(:user)
	  	habit = FactoryBot.create(:habit, record_type: true, owner: user)
	  	sign_in_as user

	    expect{
	      click_link "今日の成果を投稿"
	      fill_in "今日の成果", with: "テストを行った"
	      click_button "投稿"

	      expect(page).to have_content "テストを行った"
	      expect(page).to have_content "継続日数　　　：0日"
	      expect(page).to have_content "トータル日数　：0日"
	    }.to change(habit.posts, :count).by(1)
	  end

	  scenario "post achievements with time" do
	  	user = FactoryBot.create(:user)
	  	habit = FactoryBot.create(:habit, owner: user)
	  	achievement = FactoryBot.create(:achievement, :created_at_yesterday, habit: habit)
	  	sign_in_as user

	    expect{
	      click_link "今日の成果を投稿"
	      fill_in "今日の成果", with: "テストを行った"
	      fill_in "post_report", with: 2
	      click_button "投稿"

	      expect(page).to have_content "テストを行った"
	      expect(page).to have_content "トータル時間　：3時間"
	    }.to change(habit.posts, :count).by(1)
	  end

	  scenario "remove a post" do
	  	user = FactoryBot.create(:user)
	  	habit = FactoryBot.create(:habit, owner: user)
	  	post = FactoryBot.create(:post, habit: habit)
	  	sign_in_as user
	  	click_link "プロフィール"
	  	within ".post" do
	  		click_link "削除"
	  	end
	  	
	  	expect(habit.posts).to be_empty
	  end
	end
end
