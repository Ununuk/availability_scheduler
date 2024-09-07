module AvailabilityScheduler
  module Availability
    class FetchForUser
      def initialize(user_id:, date:)
        @user_id = user_id
        @start_date = Date.strptime(date, '%m-%Y')
        @end_date = @start_date.end_of_month
      end

      def call
        availability = {}

        special_schedules = SpecialSchedule.where(user_id: @user_id, date: @start_date..@end_date)

        weekly_schedules = WeeklySchedule.where(user_id: @user_id)

        (@start_date..@end_date).each do |date|
          availability[date.strftime('%d-%m-%Y')] = daily_availability(date, special_schedules, weekly_schedules)
        end

        availability
      end

      private

      attr_reader :user_id, :start_date, :end_date

      def daily_availability(date, special_schedules, weekly_schedules)
        special_schedules_for_day = special_schedules.select { |schedule| schedule.date == date }
        availability = special_schedules_for_day.map do |schedule|
          single_time(schedule)
        end

        return availability if availability.present?

        weekly_schedules_for_day = weekly_schedules.select { |schedule| schedule.day_of_week == date.wday }
        weekly_schedules_for_day.map do |schedule|
          single_time(schedule)
        end
      end

      def single_time(schedule)
        {
          start_time: schedule.start_time.strftime('%H:%M'),
          end_time: schedule.end_time.strftime('%H:%M')
        }
      end
    end
  end
end
