FactoryBot.define do
  factory :special_schedule, class: 'AvailabilityScheduler::SpecialSchedule' do
    user_id { 1 }
    date { Date.current }
    start_time { '10:00' }
    end_time { '12:00' }
  end
end
