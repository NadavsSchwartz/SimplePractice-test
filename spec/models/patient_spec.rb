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
end
