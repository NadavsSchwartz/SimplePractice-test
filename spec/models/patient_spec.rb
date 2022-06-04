RSpec.describe Patient do

  it "creates an appointment" do
    doctor = FactoryBot.create(:doctor, name: Faker::Name.unique.name)
    expect { FactoryBot.create(:patient, name: Faker::Name.unique.name, doctor: doctor) }
      .to change(Patient, :count).by(1)
  end
end
