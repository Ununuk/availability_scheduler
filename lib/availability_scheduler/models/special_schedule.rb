module AvailabilityScheduler
  class SpecialSchedule < Base
    self.table_name = 'special_schedules'

    validates :user_id, presence: true
    validates :date, :start_time, :end_time, presence: true
    validate :no_time_overlap

    private

    def no_time_overlap
      overlapping_schedule = SpecialSchedule.where(user_id: user_id, date: date)
                                            .where.not(id: id)
                                            .where('start_time < ? AND end_time > ?', end_time, start_time)

      return unless overlapping_schedule.exists?

      errors.add(:base, 'Special schedule overlaps with another special schedule.')
    end
  end
end
