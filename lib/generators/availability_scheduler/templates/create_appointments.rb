class CreateAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :appointments do |t|
      t.integer :booker_id, null: false
      t.integer :booked_user_id, null: false
      t.date :date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end

    add_index :appointments,
              %i[booked_user_id date start_time end_time],
              unique: true, name: 'index_appointments_on_booked_user_id_and_time'
  end
end
