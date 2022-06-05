RSpec.describe 'Api/Doctors', type: :request do
  it 'returns all doctors without appointments' do
    2.times do
      doctor = FactoryBot.create(:doctor)
      2.times do
        patient = doctor.patients.create(name: Faker::Name.unique.name)
        2.times do
          patient.appointments.create(patient: patient, doctor: doctor, duration_in_minutes: 50, start_time: Faker::Time.between(from: 2.days.from_now, to: 5.days.from_now))
        end
        2.times do
          patient.appointments.create(patient: patient, doctor: doctor, duration_in_minutes: 50, start_time: Faker::Time.between(from: 5.days.ago, to: 2.day.ago))
        end
      end
    end

    2.times do
      FactoryBot.create(:doctor)
    end

    get '/api/doctors'
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).length).to eq(2)
  end
end
