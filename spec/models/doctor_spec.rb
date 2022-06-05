RSpec.describe Doctor do
  it 'creates an appointment' do
    expect { FactoryBot.create(:doctor, name: Faker::Name.unique.name) }
      .to change(Doctor, :count).by(1)
  end

  it 'returns error if doctor name already exists' do
    doctor = FactoryBot.create(:doctor, name: Faker::Name.unique.name)

    expect { FactoryBot.create(:doctor, name: doctor.name) }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'doctor should have 10 patients, and 100 appointments, 50 in the past, 50 in the future' do
    doctor = Doctor.first
    expect(doctor.patients.count).to eq(10)
    expect(doctor.appointments.count).to eq(100)
    expect(doctor.appointments.where('start_time < ?', Time.now).count).to eq(50)
    expect(doctor.appointments.where('start_time > ?', Time.now).count).to eq(50)
  end
end
