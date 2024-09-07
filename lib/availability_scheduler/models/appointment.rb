module AvailabilityScheduler
  class Appointment < Base
    self.table_name = 'appointments'

    validates :booker_id, :booked_user_id, :date, :start_time, :end_time, presence: true
    validate :user_has_schedule
    validate :within_availability, if: lambda {
      start_time.present? && end_time.present? && date.present? && errors[:base].blank?
    }
    validate :no_overlap, if: -> { errors[:base].blank? }

    private

    def user_has_schedule
      return if SpecialSchedule.exists?(user_id: booked_user_id) || WeeklySchedule.exists?(user_id: booked_user_id)

      errors.add(:base, 'The booked user does not have any available schedules.')
    end

    def within_availability
      return if special_schedule_exists?
      return if weekly_schedule_exists?

      errors.add(:base, 'Appointment is not within the availability of the booked user.')
    end

    def no_overlap
      overlapping_appointments = Appointment.where(booked_user_id: booked_user_id, date: date)
                                            .where.not(id: id)
                                            .where('start_time < ? AND end_time > ?', end_time, start_time)

      return unless overlapping_appointments.exists?

      errors.add(:base, 'Appointment overlaps with another appointment.')
    end

    def special_schedule_exists?
      SpecialSchedule.where(user_id: booked_user_id, date: date)
                     .where('start_time <= ? AND end_time >= ?', start_time, end_time)
                     .exists?
    end

    def weekly_schedule_exists?
      WeeklySchedule.where(user_id: booked_user_id, day_of_week: date.wday)
                    .where('start_time <= ? AND end_time >= ?', start_time, end_time)
                    .exists?
    end
  end
end
