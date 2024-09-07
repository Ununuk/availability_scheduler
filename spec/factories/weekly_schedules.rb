FactoryBot.define do
  factory :weekly_schedule, class: 'AvailabilityScheduler::WeeklySchedule' do
    user_id { 1 }
    day_of_week { 0 }
    start_time { '10:00' }
    end_time { '12:00' }
  end
end
