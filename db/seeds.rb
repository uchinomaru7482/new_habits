# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

profiles = [{email: "yumi@example.com", 	name: "yumi", 		password: "aaaaaaaa", password_confirmation: "aaaaaaaa"},
         		{email: "taro@example.com", 	name: "たろう", 		password: "aaaaaaaa", password_confirmation: "aaaaaaaa"},
         		{email: "akari@example.com", 	name: "あかり", 		password: "aaaaaaaa", password_confirmation: "aaaaaaaa"},
         		{email: "shohei@example.com", name: "翔平", 			password: "aaaaaaaa", password_confirmation: "aaaaaaaa"},
         		{email: "tekki@example.com", 	name: "テッキー", 	password: "aaaaaaaa", password_confirmation: "aaaaaaaa"},
         		{email: "kazuto@example.com", name: "kazuto", 	password: "aaaaaaaa", password_confirmation: "aaaaaaaa"}]

habits1 = [{content: "1時間本を読む",     	record_type: true},
					 {content: "30分ジョギングする", 	record_type: false},
					 {content: "2時間勉強する",			 	record_type: true},
					 {content: "筋トレをする",      	record_type: false},
					 {content: "コードを書く",			 	record_type: true},
					 {content: "毎日散歩する",				record_type: false}]

posts1 = [{user_id: 1, content: "今日は「お金の真理」という本を読んだ。お金との向き合い方について考えさせられた。"},
          {user_id: 2, content: "公園をジョギングした。最近気温が下がってきて気持ちがいい。"},
          {user_id: 3, content: "英語と数学を勉強した。また明日頑張ろうと思う。"},
          {user_id: 4, content: "腹筋100回、腕立て100回。プロテインが美味しい。"},
          {user_id: 5, content: "Railsでアプリケーションを作成した。完成が待ち遠しい。"},
          {user_id: 6, content: "今日は河川敷を散歩した。いつも会うおじさんと挨拶した。"}]

6.times {|n|
	user = User.create(profiles[n])
	habit = user.habits.create(habits1[n])
	post = habit.posts.create(posts1[n])
}
#users = profiles.map {|profile| User.create(profile)}
#users.zip(habits1) {|user, habit1| habits1_create << user.habits.create(habit1)}
#habits1_create.zip(posts1) {|habit1, post1| habit1.posts.create(post1)}
