RSpec.describe AvailabilityScheduler::WeeklySchedule, type: :model do
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_inclusion_of(:day_of_week).in_array((0..6).to_a) }
  it { is_expected.to validate_presence_of(:start_time) }
  it { is_expected.to validate_presence_of(:end_time) }

  describe '#no_time_overlap' do
    let(:user_id) { 1 }

    before do
      create(:weekly_schedule, user_id: user_id, day_of_week: 0, start_time: '10:00', end_time: '12:00')
    end

    context 'when there is no overlapping schedule in different day' do
      let(:new_schedule) do
        build(:weekly_schedule, user_id: user_id, day_of_week: 1, start_time: '10:00', end_time: '12:00')
      end

      it 'does not add any errors' do
        new_schedule.valid?
        expect(new_schedule.errors[:base]).to be_empty
      end
    end

    context 'when there is an overlapping schedule' do
      let(:new_schedule) do
        build(:weekly_schedule, user_id: user_id, day_of_week: 0, start_time: '11:00', end_time: '13:00')
      end

      it 'adds errors' do
        new_schedule.valid?
        expect(new_schedule.errors[:base]).to include('Weekly schedule overlaps with another weekly schedule.')
      end
    end

    context 'when the new schedule starts when the existing one ends' do
      let(:new_schedule) do
        build(:weekly_schedule, user_id: user_id, day_of_week: 0, start_time: '13:00', end_time: '14:00')
      end

      it 'does not add any errors' do
        new_schedule.valid?
        expect(new_schedule.errors[:base]).to be_empty
      end
    end
  end
end
