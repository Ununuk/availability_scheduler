FactoryBot.define do
  factory :appointment, class: 'AvailabilityScheduler::Appointment' do
    booker_id { 1 }
    booked_user_id { 2 }
    date { '2020-01-01' }
    start_time { '10:00' }
    end_time { '12:00' }
  end
end
