RSpec.describe AvailabilityScheduler::SpecialSchedule, type: :model do
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to validate_presence_of(:start_time) }
  it { is_expected.to validate_presence_of(:end_time) }

  describe '#no_time_overlap' do
    let(:user_id) { 1 }

    before do
      create(:special_schedule, user_id: user_id, date: '2020-01-01', start_time: '10:00', end_time: '12:00')
    end

    context 'when there is no overlapping schedule in different day' do
      let(:new_schedule) do
        build(:special_schedule, user_id: user_id, date: '2020-01-02', start_time: '10:00', end_time: '12:00')
      end

      it 'does not add any errors' do
        new_schedule.valid?
        expect(new_schedule.errors[:base]).to be_empty
      end
    end

    context 'when there is an overlapping schedule' do
      let(:new_schedule) do
        build(:special_schedule, user_id: user_id, date: '2020-01-01', start_time: '11:00', end_time: '13:00')
      end

      it 'adds errors' do
        new_schedule.valid?
        expect(new_schedule.errors[:base]).to include('Special schedule overlaps with another special schedule.')
      end
    end

    context 'when the new schedule starts when the existing one ends' do
      let(:new_schedule) do
        build(:special_schedule, user_id: user_id, date: '2020-01-01', start_time: '13:00', end_time: '14:00')
      end

      it 'does not add any errors' do
        new_schedule.valid?
        expect(new_schedule.errors[:base]).to be_empty
      end
    end
  end
end
