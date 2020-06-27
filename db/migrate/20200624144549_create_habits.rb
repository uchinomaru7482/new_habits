class CreateHabits < ActiveRecord::Migration[5.2]
  def change
    create_table :habits do |t|
      t.integer :user_id
      t.string :habit_content
      t.boolean :habit_type
      t.integer :total_days
      t.time :total_time
      t.integer :continuation_days
      t.integer :open_range

      t.timestamps
    end
  end
end
