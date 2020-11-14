class CreateHabits < ActiveRecord::Migration[5.2]
  def change
    create_table :habits do |t|
      t.integer :user_id
      t.string :content, null: false
      t.boolean :report_type, default: true, null: false
      t.integer :total_days, default: 0
      t.integer :total_report, default: 0
      t.integer :continuation_days, default: 0

      t.timestamps
    end
  end
end
