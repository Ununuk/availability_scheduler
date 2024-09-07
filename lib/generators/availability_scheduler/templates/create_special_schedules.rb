class CreateSpecialSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :special_schedules do |t|
      t.integer :user_id, null: false
      t.date :date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end

    add_index :special_schedules, %i[user_id date]
  end
end
