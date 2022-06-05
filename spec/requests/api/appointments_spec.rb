require 'rails_helper'

RSpec.describe 'Api/Appointments', type: :request do
  it 'returns json object in a specific structure' do
    FactoryBot.create(:appointment)
    get api_appointments_path
    expect(response.body).to match(
      [{
        id: Integer,
        patient: {
          name: String

        },
        doctor: {
          name: String,
          id: Integer
        },
        created_at: String,
        start_time: String,
        duration_in_minutes: Integer
      }].to_json
    )
  end

  it 'returns error messages status code for invalid past param' do
    ['/api/appointments?past=bar', '/api/appointments?past=2', '/api/appointments?past='].each do |path|
      get path
      expect(response).to have_http_status(:bad_request)

      expect(JSON.parse(response.body)['error']).to eq('past must be 0 or 1')
    end
  end

  it 'returns error messages and status code for invalid page and length param' do
    possible_errors = ['page and length must be integers bigger than 0', 'page and length must be present together']

    ['/api/appointments?page=bar', '/api/appointments?page=2'].each do |path|
      get path
      expect(response).to have_http_status(:bad_request)

      # except response.body to equal one of array possible_errors

      expect(JSON.parse(response.body)['error']).to eq(possible_errors[1])
    end

    ['/api/appointments?page=1&length=bar', '/api/appointments?page=invalid&length=2', '/api/appointments?page=&length='].each do |path|
      get path
      expect(response).to have_http_status(:bad_request)

      expect(JSON.parse(response.body)['error']).to eq(possible_errors[0])
    end
  end

  it 'returns appointments in the future only for past=0 param' do
    # create 2 doctors, each doctor has 2 patients, each patient has 4 appointments, two appointment is in the past and two in the future
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

    get '/api/appointments?past=0'
    expect(response).to have_http_status(:ok)

    # sort appointments by start_time and check if first appointment is in the past
    expect(JSON.parse(response.body)[0]['start_time'].to_date.future?).to eq(true)
  end

  it 'returns appointments in the past only for past=1 param' do
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

    get '/api/appointments?past=1'
    expect(response).to have_http_status(:ok)
    # sort appointments by start_time and check if first appointment is in the past
    expect(JSON.parse(response.body)[0]['start_time'].to_date.past?).to eq(true)
  end

  it 'returns 5 appointments from first page' do
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

    get '/api/appointments?page=1&length=5'
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).length).to eq(5)
    expect(JSON.parse(response.body)[0]['id']).to eq(Appointment.first.id)
  end

  it 'returns 1 appointment from fourth page' do
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

    get '/api/appointments?page=4&length=1'
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).length).to eq(1)
    expect(JSON.parse(response.body)[0]['id']).to eq(Appointment.fourth.id)
  end

  it 'creates a new appointment if all params are valid' do
    doctor = FactoryBot.create(:doctor)
    patient = doctor.patients.create(name: Faker::Name.unique.name)

    post '/api/appointments', params: {
      patient: { name: patient.name },
      doctor: { id: doctor.id },
      duration_in_minutes: 50,
      start_time: Faker::Time.between(from: 2.days.from_now, to: 5.days.from_now)
    }
    puts response.body
    expect(response).to have_http_status(:created)
    expect(Appointment.count).to eq(1)
    expect(Appointment.first.patient).to eq(patient)
  end

  it 'returns error if doctor does not exists' do
    patient = FactoryBot.create(:patient)

    post '/api/appointments', params: {
      patient: { name: patient.name },
      doctor: { id: 'invalid' },
      duration_in_minutes: 50,
      start_time: Faker::Time.between(from: 2.days.from_now, to: 5.days.from_now)
    }
    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)['message']).to eq('Doctor not found')
  end

  it 'returns error if patient does not exists' do
    doctor = FactoryBot.create(:doctor)

    post '/api/appointments', params: {
      patient: { name: 'invalid' },
      doctor: { id: doctor.id },
      duration_in_minutes: 50,
      start_time: Faker::Time.between(from: 2.days.from_now, to: 5.days.from_now)
    }
    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)['message']).to eq('Patient not found')
  end

  it 'returns error if start_time is not valid' do
    doctor = FactoryBot.create(:doctor)
    patient = doctor.patients.create(name: Faker::Name.unique.name)

    post '/api/appointments', params: {
      patient: { name: patient.name },
      doctor: { id: doctor.id },
      duration_in_minutes: 50,
      start_time: 'invalid'
    }
    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)['message']).to eq("Start time can't be blank, Start time must be a valid date format")
  end

  it 'returns error if duration_in_minutes is not valid' do
    doctor = FactoryBot.create(:doctor)
    patient = doctor.patients.create(name: Faker::Name.unique.name)

    post '/api/appointments', params: {
      patient: { name: patient.name },
      doctor: { id: doctor.id },
      duration_in_minutes: 10,
      start_time: Faker::Time.between(from: 2.days.from_now, to: 5.days.from_now)
    }
    expect(response).to have_http_status(:bad_request)
    expect(JSON.parse(response.body)['message']).to eq('Duration in minutes must be 50 minutes')
  end
end
