RSpec.describe Appointment do
  it 'creates an appointment' do
    expect { FactoryBot.create(:appointment) }.to change(Appointment, :count).by(1)
  end

  it 'should have 1000 appointments, 500 in the past, 500 in the futuurer' do
    expect(Appointment.all.count).to eq(1000)
    expect(Appointment.where('start_time < ?', Time.now).count).to eq(500)
    expect(Appointment.where('start_time > ?', Time.now).count).to eq(500)
  end
end
