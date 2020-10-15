# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

today = Date.today

profiles = [{ email: "yumi@example.com",   name: "yumi",    password: "aaaaaaaa", password_confirmation: "aaaaaaaa", confirmed_at: Time.now },
            { email: "taro@example.com",   name: "たろう", 	password: "aaaaaaaa", password_confirmation: "aaaaaaaa", confirmed_at: Time.now },
            { email: "akari@example.com",  name: "あかり", 	password: "aaaaaaaa", password_confirmation: "aaaaaaaa", confirmed_at: Time.now },
            { email: "shohei@example.com", name: "翔平", 		password: "aaaaaaaa", password_confirmation: "aaaaaaaa", confirmed_at: Time.now },
            { email: "tekki@example.com",  name: "テッキー", 	password: "aaaaaaaa", password_confirmation: "aaaaaaaa", confirmed_at: Time.now },
            { email: "kazuto@example.com", name: "kazuto", 	password: "aaaaaaaa", password_confirmation: "aaaaaaaa", confirmed_at: Time.now }]

habits1 = [{ content: "1時間本を読む",     	record_type: false, total_days: 6, total_time: 9, continuation_days: 6 },
           { content: "30分ジョギングする", 	record_type: false, total_days: 1, total_time: 1, continuation_days: 1 },
           { content: "2時間勉強する",			record_type: false, total_days: 1, total_time: 2, continuation_days: 1 },
           { content: "筋トレをする",      	record_type: true,  total_days: 1,                continuation_days: 1 },
           { content: "コードを書く",			 	record_type: true,  total_days: 1,                continuation_days: 1 },
           { content: "毎日散歩する",				record_type: true,  total_days: 1,                continuation_days: 1 }]

posts1 = [{ user_id: 1, content: "今日は「お金の真理」という本を読んだ。お金との向き合い方について考えさせられた。" },
          { user_id: 2, content: "公園をジョギングした。最近気温が下がってきて気持ちがいい。" },
          { user_id: 3, content: "英語と数学を勉強した。また明日頑張ろうと思う。" },
          { user_id: 4, content: "腹筋100回、腕立て100回。プロテインが美味しい。" },
          { user_id: 5, content: "Railsでアプリケーションを作成した。完成が待ち遠しい。" },
          { user_id: 6, content: "今日は河川敷を散歩した。いつも会うおじさんと挨拶した。" }]

achievements1 = [{ check: true, report: 1 },
                 { check: true, report: 1 },
                 { check: true, report: 2 },
                 { check: true, report: 0 },
                 { check: true, report: 0 },
                 { check: true, report: 0 }]

yumi_posts = [{ user_id: 1, content: "今日は「具体と抽象」という本を読んだ。頭が良くなった気がする。",               created_at: today - 1 },
              { user_id: 1, content: "今日は「時間革命」という本を読んだ。無駄な事をしている時間はないと感じた。",     created_at: today - 2 },
              { user_id: 1, content: "今日は「メモの魔力」という本を読んだ。明日からやってみようと思う。",            created_at: today - 3 },
              { user_id: 1, content: "今日は「Railsチュートリアル」という本を読んだ。Railsの基礎を理解した。",       created_at: today - 4 },
              { user_id: 1, content: "今日は「Ruby入門」という本を読んだ。rubyの基礎が分かった。",                  created_at: today - 5 }]

yumi_achievements = [{ check: true, report: 2, created_at: today - 1 },
                     { check: true, report: 1, created_at: today - 2 },
                     { check: true, report: 3, created_at: today - 3 },
                     { check: true, report: 1, created_at: today - 4 },
                     { check: true, report: 1, created_at: today - 5 }]

6.times do |n|
  user = User.create!(profiles[n])
  habit = user.habits.create!(habits1[n])
  habit.posts.create!(posts1[n])
  habit.achievements.create!(achievements1[n])
end

5.times do |n|
  habit = Habit.find_by(content: "1時間本を読む")
  habit.posts.create!(yumi_posts[n])
  habit.achievements.create!(yumi_achievements[n])
end

user = User.find(1)
habit = user.habits.create!(content: "毎日自炊する", record_type: true, total_days: 2, continuation_days: 1)
habit.posts.create!(user_id: 1, content: "青椒肉絲を作った。本格中華を家で作ることができて嬉しい。")
habit.posts.create!(user_id: 1, content: "餃子を作った。実家の味が再現できていたような気がする。", created_at: today - 2)
habit.achievements.create!(check: true)
habit.achievements.create!(check: true, created_at: today - 2)

users = User.all
user = User.find(1)
following = users[2..6]
followers = users[3..6]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
