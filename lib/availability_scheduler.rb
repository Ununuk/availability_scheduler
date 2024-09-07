require 'availability_scheduler/railtie' if defined?(Rails)

module AvailabilityScheduler
  class Error < StandardError; end

  autoload :Base, 'availability_scheduler/base'
  autoload :WeeklySchedule, 'availability_scheduler/models/weekly_schedule'
  autoload :SpecialSchedule, 'availability_scheduler/models/special_schedule'
  autoload :Appointment, 'availability_scheduler/models/appointment'
  autoload :Availability, 'availability_scheduler/services/availability/fetch_for_user'
end
