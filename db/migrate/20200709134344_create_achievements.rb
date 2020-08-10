class CreateAchievements < ActiveRecord::Migration[5.2]
  def change
    create_table :achievements do |t|
      t.integer :habit_id
      t.boolean :check, default: false, null: false
      t.integer :report, default: 0

      t.timestamps
    end
  end
end
