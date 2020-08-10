class CreateAchievements < ActiveRecord::Migration[5.2]
  def change
    create_table :achievements do |t|
      t.integer :habit_id
      t.boolean :check, null: false
      t.integer :report

      t.timestamps
    end
  end
end
