# frozen_string_literal: true

class Appointment < ApplicationRecord
  
  belongs_to :doctor
  belongs_to :patient

  def self.join_tables_and_modify_response(appointments)
    (
      appointments
        .joins(:patient, :doctor)
        .select(
          'appointments.*, patients.name as patient_name, patients.id as patient_id, doctors.name as doctor_name, doctors.id as doctor_id'
        )
        .map do |appointment|
          {
            id: appointment.id,
            patient: {
              name: appointment.patient_name
            },
            doctor: {
              name: appointment.doctor_name,
              id: appointment.doctor_id
            },
            created_at: appointment.created_at.iso8601,
            start_time: appointment.start_time.iso8601,
            duration_in_minutes: appointment.duration_in_minutes
          }
        end
    )
  end
end
