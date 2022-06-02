# TODO: Seed the database according to the following requirements:

# - There should be 10 Doctors with unique names

10.times { Doctor.create(name: Faker::Name.unique.name) }

# - Each doctor should have 10 patients with unique names
Doctor.all.each do |doctor|
	10.times do
		doctor.patients.create(name: Faker::Name.unique.name, doctor_id: doctor.id)
	end
end

# - Each patient should have 10 appointments
# - 5 in the past, 5 in the future
# - Each appointment should be 50 minutes in duration

#add id to patients

Patient.all.each do |patient|
	5.times do
		patient.appointments.create(
			start_time:
				Faker::Time.between(
					from: DateTime.now + 15.days,
					to: DateTime.now + 25.days,
					format: :default,
				),
			duration_in_minutes: 50,
			patient_id: patient.id,
			doctor_id: patient.doctor_id,
		)
	end
	5.times do
		patient.appointments.create(
			start_time:
				Faker::Time.between(
					from: DateTime.now - 25.days,
					to: DateTime.now - 15.days,
					format: :default,
				),
			duration_in_minutes: 50,
			patient_id: patient.id,
			doctor_id: patient.doctor_id,
		)
	end
end
