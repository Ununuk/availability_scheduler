class CreateWeeklySchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :weekly_schedules do |t|
      t.integer :user_id, null: false
      t.integer :day_of_week, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end

    add_index :weekly_schedules, :user_id
  end
end
