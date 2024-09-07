
# AvailabilityScheduler

`AvailabilityScheduler` is a Ruby on Rails gem for managing user availability and scheduling appointments. It ensures appointments are booked within the user's available time slots and prevents overlapping bookings. The gem supports both recurring weekly schedules and one-off special schedules.

## Features

- Manage weekly recurring schedules and one-off special schedules for users.
- Book appointments within a user’s availability.
- Prevent overlapping appointments.
- Validate availability before confirming an appointment.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'availability_scheduler'
```

And then execute:

```bash
bundle install
```

Next, run the generator to create the necessary migration files:

```bash
rails generate availability_scheduler:install
```

Finally, migrate your database:

```bash
rails db:migrate
```

## Usage

### Setting Weekly Schedules

Define recurring weekly schedules for users.

```ruby
# Define a weekly schedule for a user
AvailabilityScheduler::WeeklySchedule.create!(
  user_id: 1,
  day_of_week: 1, # Monday
  start_time: '09:00',
  end_time: '17:00'
)
```

### Setting Special Schedules

Define one-off special schedules for specific dates.

```ruby
# Define a special schedule for a specific date
AvailabilityScheduler::SpecialSchedule.create!(
  user_id: 1,
  date: '2024-09-10',
  start_time: '10:00',
  end_time: '14:00'
)
```

### Booking an Appointment

Book an appointment with validation to ensure it’s within the user’s availability.

```ruby
AvailabilityScheduler::Appointment.create!(
  booker_id: 2, # User making the booking
  booked_user_id: 1, # User being booked
  date: '2024-09-10',
  start_time: '11:00',
  end_time: '12:00'
)
```

### Fetching Availability for a User

You can fetch the availability of a user for a given month using the `AvailabilityScheduler::Availability::FetchForUser` service. This service returns a hash where each day of the month is mapped to an array of availability time periods.

#### Example

```ruby
availability_service = AvailabilityScheduler::Availability::FetchForUser.new(user_id: 1, date: '05-2024')
availability = availability_service.call

availability.each do |date, periods|
  if periods.any?
    periods.each do |period|
      puts "#{date}: Available from #{period[:start_time]} to #{period[:end_time]}"
    end
  else
    puts "#{date}: Not available"
  end
end
```
Example output:
```ruby
{
  "2024-05-01" => [{ start_time: "09:00", end_time: "10:00" }, { start_time: "11:00", end_time: "16:00" }],
  "2024-05-02" => [],
  "2024-05-03" => [{ start_time: "10:00", end_time: "14:00" }],
  # ...
}
```

### Validation Example

The gem will automatically validate whether the appointment is within the availability and if it overlaps with any other appointments.

```ruby
appointment = AvailabilityScheduler::Appointment.new(
  booker_id: 2,
  booked_user_id: 1,
  date: '2024-09-10',
  start_time: '11:00',
  end_time: '12:00'
)

if appointment.save
  puts 'Appointment successfully booked!'
else
  puts appointment.errors.full_messages
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/yourusername/availability_scheduler](https://github.com/yourusername/availability_scheduler).

## License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
