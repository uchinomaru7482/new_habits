class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :habit_id
      t.integer :user_id
      t.text :content
      t.time :execution_time

      t.timestamps
    end
  end
end
