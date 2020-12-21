require "rails_helper"

RSpec.feature "Projects", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:habit) { FactoryBot.create(:habit, owner: user) }
  let(:post) { FactoryBot.create(:post, habit: habit, user: user) }

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

      expect { click_button "新規登録" }.to change { ActionMailer::Base.deliveries.size }.by(1)
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

      expect(page).to have_content user2.name

      click_link "ホーム"

      expect(page).to have_content post2.content

      click_link "ログアウト"
      sign_in_as user2
      click_link "プロフィール"
      click_link "フォロワー：1"

      expect(page).to have_content user1.name
    end

    scenario "edit user" do
      sign_in_as user
      click_link "プロフィール"
      click_link "プロフィールを編集"
      fill_in "メールアドレス", with: "edittester@example.com"
      fill_in "現在のパスワード", with: "aaaaaaaa"

      expect { click_button "保存" }.to change { ActionMailer::Base.deliveries.size }.by(1)
      expect(page).to have_content "アカウントは正常に更新されましたが、新しいメールアドレスを確認する必要があります。"

      edit_user = User.find(user.id)
      token = edit_user.confirmation_token
      visit user_confirmation_path(confirmation_token: token)

      expect(page).to have_content "メールアドレスの確認が完了しました。"
    end
  end

  describe "habit" do
    scenario "register a check type habit" do
      sign_in_as user

      expect do
        click_link "習慣登録"
        fill_in "習慣名", with: "習慣登録テスト"
        click_button "登録"

        expect(page).to have_content "習慣を登録しました"
        expect(page).to have_content "習慣登録テスト"
        expect(page).to_not have_content "トータル時間　：0時間"
      end.to change(user.habits, :count).by(1)
    end

    scenario "register a report type habit" do
      sign_in_as user

      expect do
        click_link "習慣登録"
        fill_in "習慣名", with: "習慣登録テスト"
        choose "habit_report_type_false"
        click_button "登録"

        expect(page).to have_content "習慣を登録しました"
        expect(page).to have_content "習慣登録テスト"
        expect(page).to have_content "トータル実績　：0時間"
      end.to change(user.habits, :count).by(1)
    end

    scenario "remove a habit" do
      habit = FactoryBot.create(:habit, owner: user)
      FactoryBot.create(:post, habit: habit)
      sign_in_as user
      click_link "プロフィール"
      within ".habit" do
        click_link "削除"
      end

      expect(user.habits).to be_empty
      expect(habit.posts).to be_empty
    end

    scenario "edit a habit" do
      FactoryBot.create(:habit, owner: user)
      sign_in_as user
      click_link "プロフィール"
      click_link "編集"
      fill_in "習慣名", with: "習慣編集テスト"
      fill_in "記録単位", with: "分"
      click_button "保存"

      expect(page).to have_content "習慣編集テスト"
      expect(page).to have_content "分"
    end

    scenario "search a habit" do
      other_user = FactoryBot.create(:user)
      FactoryBot.create(:habit, content: "習慣検索テスト", owner: other_user)
      sign_in_as user
      click_link "習慣検索"
      fill_in "キーワードを入力", with: "習慣検索"
      click_button "検索"

      expect(page).to have_content "習慣検索テスト"
    end
  end

  describe "post" do
    scenario "post achievements with check" do
      habit = FactoryBot.create(:habit, report_type: true, owner: user)
      sign_in_as user

      expect do
        click_link "今日の成果を投稿"
        fill_in "今日の成果", with: "テストを行った"
        check "post[check]"
        click_button "投稿"

        expect(page).to have_content "テストを行った"
        expect(page).to have_content "継続日数　　　：1日"
        expect(page).to have_content "トータル日数　：1日"
      end.to change(habit.posts, :count).by(1)
    end

    scenario "post achievements without check" do
      habit = FactoryBot.create(:habit, report_type: true, owner: user)
      sign_in_as user

      expect do
        click_link "今日の成果を投稿"
        fill_in "今日の成果", with: "テストを行った"
        click_button "投稿"

        expect(page).to have_content "テストを行った"
        expect(page).to have_content "継続日数　　　：0日"
        expect(page).to have_content "トータル日数　：0日"
      end.to change(habit.posts, :count).by(1)
    end

    scenario "post achievements with time" do
      FactoryBot.create(:achievement, :created_at_yesterday, habit: habit)
      sign_in_as user

      expect do
        click_link "今日の成果を投稿"
        fill_in "今日の成果", with: "テストを行った"
        fill_in "post_report", with: 2
        click_button "投稿"

        expect(page).to have_content "テストを行った"
        expect(page).to have_content "トータル実績　：3時間"
      end.to change(habit.posts, :count).by(1)
    end

    scenario "remove a post" do
      FactoryBot.create(:post, habit: habit)
      sign_in_as user
      click_link "プロフィール"
      within ".post" do
        click_link "削除"
      end

      expect(habit.posts).to be_empty
    end

    describe "like" do
      scenario "like to post from root path" do
        post = FactoryBot.create(:post, habit: habit)
        sign_in_as user

        expect do
          click_link "like_icon"

          expect(page).to have_selector ".delete_like_button", text: "1"
          expect(current_path).to eq root_path
        end.to change(post.likes, :count).by(1)
      end

      scenario "remove like" do
        post = FactoryBot.create(:post, habit: habit)
        sign_in_as user
        click_link "like_icon"

        expect do
          click_link "like_icon"

          expect(page).to have_selector ".add_like_button", text: "0"
          expect(current_path).to eq root_path
        end.to change(post.likes, :count).by(-1)
      end

      scenario "like to post from user path" do
        FactoryBot.create(:post, habit: habit)
        sign_in_as user
        click_link "プロフィール"
        click_link "like_icon"

        expect(page).to have_selector ".delete_like_button", text: "1"
        expect(current_path).to eq user_path(user)
      end
    end
  end

  describe "comment" do
    scenario "post a comment" do
      post = FactoryBot.create(:post, habit: habit, user: user)
      sign_in_as user

      expect do
        click_link "comment_icon"
        fill_in "コメント", with: "テストコメント"
        click_button "投稿"

        expect(page).to have_content "テストコメント"
      end.to change(post.comments, :count).by(1)
    end

    scenario "remove a comment" do
      FactoryBot.create(:comment, post: post, user: user)
      sign_in_as user
      click_link "comment_icon"
      click_link "削除"

      expect(post.comments).to be_empty
    end
  end

  describe "admin" do
    context "when not admin" do
      let(:user) { FactoryBot.create(:user, admin: false) }

      scenario "management screen is not displayed" do
        sign_in_as user
        visit admin_users_path

        expect(page).to have_content "管理者権限がありません"
      end
    end

    context "when admin" do
      let(:user) { FactoryBot.create(:user, admin: true) }

      scenario "delete user", js: true do
        delete_user = FactoryBot.create(:user, id: 2)
        sign_in_as user
        click_link "管理画面"
        page.accept_confirm do
          click_link "削除"
        end

        expect(page).to have_content "ユーザー「#{delete_user.name}」を削除しました"
      end

      scenario "cancel confirmation", js: true do
        delete_user = FactoryBot.create(:user, id: 2)
        sign_in_as user
        click_link "管理画面"
        page.dismiss_confirm do
          click_link "削除"
        end

        expect(page).to have_content delete_user.name.to_s
      end
    end
  end
end
