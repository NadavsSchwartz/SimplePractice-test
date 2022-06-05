RSpec.describe Patient do
  it 'creates an appointment' do
    doctor = FactoryBot.create(:doctor, name: Faker::Name.unique.name)
    expect { FactoryBot.create(:patient, name: Faker::Name.unique.name, doctor: doctor) }
      .to change(Patient, :count).by(1)
  end

  it 'returns error if patient name already exists' do
    patient = FactoryBot.create(:patient, name: Faker::Name.unique.name)

    expect { FactoryBot.create(:patient, name: patient.name) }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'patient should have 10 appointments, 5 in the past, 5 in the future' do
    patient = Patient.first
    expect(patient.appointments.count).to eq(10)
    expect(patient.appointments.where('start_time < ?', Time.now).count).to eq(5)
    expect(patient.appointments.where('start_time > ?', Time.now).count).to eq(5)
  end
end
