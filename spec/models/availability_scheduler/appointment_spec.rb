RSpec.describe AvailabilityScheduler::Appointment, type: :model do
  it { is_expected.to validate_presence_of(:booker_id) }
  it { is_expected.to validate_presence_of(:booked_user_id) }
  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to validate_presence_of(:start_time) }
  it { is_expected.to validate_presence_of(:end_time) }

  describe '#user_has_schedule' do
    let(:booked_user_id) { 1 }

    context 'when the booked user has a schedule' do
      before do
        create(:weekly_schedule, user_id: booked_user_id)
      end

      let(:appointment) { build(:appointment, booked_user_id: booked_user_id) }

      it 'does not add error' do
        appointment.valid?
        expect(appointment.errors[:base]).not_to include('The booked user does not have any available schedules.')
      end
    end

    context 'when the booked user does not have a schedule' do
      let(:appointment) { build(:appointment, booked_user_id: booked_user_id) }

      it 'adds errors' do
        appointment.valid?
        expect(appointment.errors[:base]).to include('The booked user does not have any available schedules.')
      end
    end
  end

  describe '#within_availability' do
    let(:booked_user_id) { 1 }
    let(:date) { '2020-01-01' }

    context 'when the appointment is within the availability' do
      before do
        create(:weekly_schedule, user_id: booked_user_id, day_of_week: date.to_date.wday, start_time: '10:00',
                                 end_time: '12:00')
      end

      let(:appointment) do
        build(:appointment, booked_user_id: booked_user_id, date: date, start_time: '10:00', end_time: '12:00')
      end

      it 'does not add any errors' do
        appointment.valid?
        expect(appointment.errors[:base]).to be_empty
      end
    end

    context 'when the appointment is not within the availability' do
      before do
        create(:weekly_schedule, user_id: booked_user_id, day_of_week: date.to_date.wday, start_time: '10:00',
                                 end_time: '12:00')
      end

      let(:appointment) do
        build(:appointment, booked_user_id: booked_user_id, date: date, start_time: '12:00', end_time: '14:00')
      end

      it 'adds errors' do
        appointment.valid?
        expect(appointment.errors[:base]).to include('Appointment is not within the availability of the booked user.')
      end
    end
  end

  describe '#no_overlap' do
    let(:booked_user_id) { 1 }
    let(:date) { '2020-01-01' }
    let(:booker_id) { 2 }

    before do
      create(:special_schedule, user_id: booked_user_id, date: date, start_time: '10:00', end_time: '14:00')
      create(:appointment, booked_user_id: booked_user_id, date: date, start_time: '10:00', end_time: '12:00')
    end

    context 'when there is no overlapping appointment' do
      let(:new_appointment) do
        build(:appointment, booked_user_id: booked_user_id, date: date, start_time: '12:00', end_time: '14:00')
      end

      it 'does not add any errors' do
        new_appointment.valid?
        expect(new_appointment.errors[:base]).to be_empty
      end
    end

    context 'when there is an overlapping appointment' do
      let(:new_appointment) do
        build(:appointment, booked_user_id: booked_user_id, date: date, start_time: '11:00', end_time: '13:00')
      end

      it 'adds errors' do
        new_appointment.valid?
        expect(new_appointment.errors[:base]).to include('Appointment overlaps with another appointment.')
      end
    end
  end
end
