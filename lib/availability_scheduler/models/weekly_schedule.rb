module AvailabilityScheduler
  class WeeklySchedule < Base
    self.table_name = 'weekly_schedules'

    validates :user_id, presence: true
    validates :day_of_week, inclusion: { in: 0..6 } # monday 0 .. sunday 6
    validates :start_time, :end_time, presence: true

    validate :no_time_overlap

    private

    def no_time_overlap
      overlapping_schedules = WeeklySchedule.where(user_id: user_id, day_of_week: day_of_week)
                                            .where.not(id: id)
                                            .where('start_time < ? AND end_time > ?', end_time, start_time)

      return unless overlapping_schedules.exists?

      errors.add(:base, 'Weekly schedule overlaps with another weekly schedule.')
    end
  end
end
