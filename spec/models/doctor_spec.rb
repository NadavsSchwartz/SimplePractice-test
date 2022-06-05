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
end
