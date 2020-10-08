require 'rails_helper'

RSpec.feature "Projects", type: :feature do

	let(:user) {FactoryBot.create(:user)}
	let(:habit) {FactoryBot.create(:habit, owner: user)}

  describe "user" do
  	background do
  		ActionMailer::Base.deliveries.clear
  	end

	  scenario "user sign up" do
	  	visit "/"
	  	within ".app_title" do
	  	  click_link "新規登録"
	  	end
	  	fill_in "メールアドレス", with: "example@example.com"
	  	fill_in "ニックネーム", with: "example"
	  	fill_in "パスワード", with: "aaaaaaaa"
	  	fill_in "パスワード確認", with: "aaaaaaaa"

	  	expect{click_button "新規登録"}.to change{ActionMailer::Base.deliveries.size}.by(1)
	  	expect(page).to have_content "確認メールを送信しました。リンクをクリックしてアカウントを有効にして下さい。"

	  	user = User.last
	  	token = user.confirmation_token
	  	visit user_confirmation_path(confirmation_token: token)

	  	expect(page).to have_content "メールアドレスの確認が完了しました。"
	  end

	  scenario "user sign in" do
	  	visit "/"
	  	within ".app_title" do
	  	  click_link "ログイン"
	  	end
	    fill_in "メールアドレス", with: user.email
	    fill_in "パスワード", with: user.password	
	    click_button "ログイン"

	    expect(page).to have_content "ログインしました。"
	  end

	  scenario "user logout" do
	  	sign_in_as user
	  	click_link "ログアウト"

	  	expect(page).to have_content "ログアウトしました。"
	  end

	  scenario "follow user" do
	  	user1 = FactoryBot.create(:user)
	  	user2 = FactoryBot.create(:user)
	  	habit2 = FactoryBot.create(:habit, owner: user2)
	  	post2 = FactoryBot.create(:post, habit: habit2)
	  	sign_in_as user1
	  	visit "/users/#{user2.id}"
	  	click_button "フォローする"
	  	click_link "プロフィール"
	  	click_link "フォロー：1"

	  	expect(page).to have_content "#{user2.name}"

	  	click_link "ホーム"

	  	expect(page).to have_content "#{post2.content}"

	  	click_link "ログアウト"
	  	sign_in_as user2
	  	click_link "プロフィール"
	  	click_link "フォロワー：1"

	  	expect(page).to have_content "#{user1.name}"
	  end

	  scenario "edit user" do
	  	sign_in_as user
	  	click_link "プロフィール"
	  	click_link "プロフィールを編集"
	  	fill_in "メールアドレス", with: "edittester@example.com"
	  	fill_in "現在のパスワード", with: "aaaaaaaa"
	  	click_button "保存"
	  	edit_user = User.find(user.id)

	  	expect(page).to have_content "アカウントが更新されました。"
	  	expect(edit_user.email).to eq "edittester@example.com"
	  end
  end

  describe "habit" do
	  scenario "register a check type habit" do
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

	  scenario "edit a habit" do
	  	habit = FactoryBot.create(:habit, owner: user)
	  	sign_in_as user
	  	click_link "プロフィール"
	  	click_link "編集"
	  	fill_in "習慣名", with: "習慣編集テスト"
	  	click_button "保存"

	  	expect(page).to have_content "習慣編集テスト"
	  end
	end

	describe "post" do
	  scenario "post achievements with check" do
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
