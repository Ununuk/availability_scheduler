require 'availability_scheduler'
require 'active_record'
require 'shoulda-matchers'
require 'pry'
require 'pry-byebug'
require 'database_cleaner/active_record'
require 'factory_bot'
FactoryBot.find_definitions

ActiveRecord::Base.establish_connection(adapter: 'sqlite3',
                                        database: ':memory:')

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :appointments, force: true do |t|
    t.integer :booker_id, null: false
    t.integer :booked_user_id, null: false
    t.date :date, null: false
    t.time :start_time, null: false
    t.time :end_time, null: false

    t.timestamps
  end

  add_index :appointments, %i[booked_user_id date start_time end_time],
            unique: true,
            name: 'index_appointments_on_booked_user_id_and_time'

  create_table :special_schedules, force: true do |t|
    t.integer :user_id, null: false
    t.date :date, null: false
    t.time :start_time, null: false
    t.time :end_time, null: false

    t.timestamps
  end

  add_index :special_schedules, %i[user_id date]

  create_table :weekly_schedules, force: true do |t|
    t.integer :user_id, null: false
    t.integer :day_of_week, null: false
    t.time :start_time, null: false
    t.time :end_time, null: false

    t.timestamps
  end

  add_index :weekly_schedules, :user_id
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
  end
end
