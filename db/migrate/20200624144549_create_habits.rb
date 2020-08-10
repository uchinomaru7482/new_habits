class CreateHabits < ActiveRecord::Migration[5.2]
  def change
    create_table :habits do |t|
      t.integer :user_id
      t.string :content, null: false
      t.boolean :record_type, null: false
      t.integer :total_days
      t.integer :total_time
      t.integer :continuation_days
      t.integer :open_range

      t.timestamps
    end
  end
end
