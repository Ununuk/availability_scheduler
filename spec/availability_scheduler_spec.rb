RSpec.describe AvailabilityScheduler do
  it 'has a version number' do
    expect(AvailabilityScheduler::VERSION).not_to be_nil
  end

  it 'does something useful' do
    expect(AvailabilityScheduler::Appointment.count).to eq(0)
  end
end
