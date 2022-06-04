# frozen_string_literal: true

module Api
  class AppointmentsController < ApplicationController
    has_scope :past, type: :boolean
    has_scope :page, type: :integer
    has_scope :length, type: :integer

    def index
      @appointments = ::GetAppointments.new(Appointment.all).call(get_appointments_params)

      # if @appointments is an error hash, return it
      if @appointments.is_a?(Hash)
        render json: @appointments, status: :bad_request
      else
        render json: Appointment.join_tables_and_modify_response(@appointments), status: :ok
      end
    end

    def create
      if @appointment = Appointment.create(appointment_params)
        render json: @appointment
      else
        render json: @appointment.errors, status: :unprocessable_entity
      end
    end

    private

    def get_appointments_params
      params.permit(:past, :page, :length)
    end

    def appointment_params
      params.require(:appointment).permit(:start_time, :duration_in_minutes, :patient_id, :doctor_id)
    end
  end
end
