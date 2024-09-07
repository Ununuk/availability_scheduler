RSpec.describe AvailabilityScheduler::Availability::FetchForUser do
  describe '#call' do
    let(:service_call) { described_class.new(user_id: user_id, date: date).call }
    let(:user_id) { 1 }
    let(:date) { '02-2021' }
    let(:start_date) { Date.strptime(date, '%m-%Y') }
    let(:end_date) { start_date.end_of_month }
    let(:valid_availability) do
      { '01-02-2021' => [{ start_time: '09:00', end_time: '11:00' }, { start_time: '13:00', end_time: '16:00' }],
        '02-02-2021' => [], '03-02-2021' => [], '04-02-2021' => [], '05-02-2021' => [],
        '06-02-2021' => [{ start_time: '18:00', end_time: '20:00' }],
        '07-02-2021' => [],
        '08-02-2021' => [{ start_time: '10:00', end_time: '12:00' }, { start_time: '14:00', end_time: '16:00' }],
        '09-02-2021' => [], '10-02-2021' => [], '11-02-2021' => [], '12-02-2021' => [],
        '13-02-2021' => [{ start_time: '18:00', end_time: '20:00' }],
        '14-02-2021' => [],
        '15-02-2021' => [{ start_time: '10:00', end_time: '12:00' }, { start_time: '14:00', end_time: '16:00' }],
        '16-02-2021' => [], '17-02-2021' => [], '18-02-2021' => [], '19-02-2021' => [],
        '20-02-2021' => [{ start_time: '18:00', end_time: '20:00' }],
        '21-02-2021' => [],
        '22-02-2021' => [{ start_time: '10:00', end_time: '12:00' }, { start_time: '14:00', end_time: '16:00' }],
        '23-02-2021' => [], '24-02-2021' => [], '25-02-2021' => [], '26-02-2021' => [],
        '27-02-2021' => [{ start_time: '18:00', end_time: '20:00' }],
        '28-02-2021' => [] }
    end

    before do
      create(:special_schedule, user_id: user_id, date: start_date, start_time: '9:00', end_time: '11:00')
      create(:special_schedule, user_id: user_id, date: start_date, start_time: '13:00', end_time: '16:00')

      create(:weekly_schedule, user_id: user_id, day_of_week: start_date.wday, start_time: '10:00', end_time: '12:00')
      create(:weekly_schedule, user_id: user_id, day_of_week: start_date.wday, start_time: '14:00', end_time: '16:00')
      create(:weekly_schedule, user_id: user_id, day_of_week: 6, start_time: '18:00', end_time: '20:00')
    end

    it 'returns the availability for the user in the given month' do
      expect(service_call).to match_array(valid_availability)
    end
  end
end
