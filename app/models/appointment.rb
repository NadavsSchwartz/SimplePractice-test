# frozen_string_literal: true

class Appointment < ApplicationRecord
  validate :start_time_must_be_in_the_future, on: :create
  belongs_to :doctor
  belongs_to :patient

  # validates start time is valid date format
  validates :start_time, presence: true, format: { with: %r{(\d{1,2}[-/]\d{1,2}[-/]\d{4})|(\d{4}[-/]\d{1,2}[-/]\d{1,2})}, message: 'must be a valid date format' }

  # validates duration is a number and equal to 50
  validates :duration_in_minutes, presence: true, numericality: { only_integer: true, equal_to: 50, message: 'must be 50 minutes' }, on: :create

  # validates start time is in the future
  def start_time_must_be_in_the_future
    errors.add(:start_time, 'must be in the future') if start_time.present? && start_time < Time.now - 1.minute
  end

  # joins patient and doctor tables and modifies response per requirements
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
