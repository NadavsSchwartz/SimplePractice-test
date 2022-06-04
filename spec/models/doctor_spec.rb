RSpec.describe Doctor do

  it "creates an appointment" do
    
    expect { FactoryBot.create(:doctor, name: Faker::Name.unique.name) }
      .to change(Doctor, :count).by(1)
  end
end
