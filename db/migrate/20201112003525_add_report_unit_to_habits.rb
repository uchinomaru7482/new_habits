class AddReportUnitToHabits < ActiveRecord::Migration[5.2]
  def change
    add_column :habits, :report_unit, :string, after: :continuation_days, default: "時間", null: false
  end
end
