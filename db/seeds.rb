# TODO: Seed the database according to the following requirements:

10.times do
  # # - There should be 10 Doctors with unique names
  doctor = Doctor.create(name: Faker::Name.unique.name)
  10.times do
    # - Each doctor should have 10 patients with unique names
    patient = doctor.patients.create(name: Faker::Name.unique.name)
    5.times do
      # - Each patient should have 5 appointments  5 in the future
      patient.appointments.create(
        start_time: Faker::Time.between(from: 5.days.from_now, to: 20.days.from_now),
        # - Each appointment should be 50 minutes in duration
        duration_in_minutes: 50,
        doctor_id: doctor.id,
        patient_id: patient.id
      )
    end
    # - Each patient should have 5 appointments  5 in the past
    5.times do
      patient.appointments.create(
        start_time: Faker::Time.between(from: 20.days.ago, to: 5.days.ago),
        # - Each appointment should be 50 minutes in duration
        duration_in_minutes: 50,
        doctor_id: doctor.id,
        patient_id: patient
      )
    end
  end
end
