# frozen_string_literal: true

module Api
  class AppointmentsController < ApplicationController
    around_action :raise_action_on_unpermitted_parameters, only: %i[index]

    def index
      @appointments = ::GetAppointments.new(Appointment.all).call(find_appointments_params)

      # if @appointments is an hash, it means there was an error
      if @appointments.is_a?(Hash)
        render json: @appointments, status: :bad_request
      else
        render json: Appointment.join_tables_and_modify_response(@appointments), status: :ok
      end
    end

    def create
      params = create_new_appointment_params
      @patient_name = params[:patient][:name].to_s
      @doctor_id = params[:doctor][:id].to_i
      @start_time = params[:start_time]
      @duration_in_minutes = params[:duration_in_minutes].to_i

      # find patient by name and return error if not found
      @patient = Patient.find_by(name: @patient_name)
      render json: { message: 'Patient not found' }, status: :bad_request and return if @patient.nil?

      # find doctor by id and return error if not found
      @doctor = Doctor.find_by(id: @doctor_id)
      render json: { message: 'Doctor not found' }, status: :bad_request and return if @doctor.nil?

      # create new appointment
      @new_appointment = Appointment.new(
        start_time: @start_time,
        duration_in_minutes: @duration_in_minutes,
        patient: @patient,
        doctor: @doctor
      )

      # if appointment is valid, and successfully saved, return successufully created appointment, else return error
      if @new_appointment.valid? && @new_appointment.save

        render json: @new_appointment, status: :created
      else
        render json: { message: @new_appointment.errors.full_messages.join(', ') }, status: :bad_request
      end
    end

    private

    # handle unpermitted parameters
    def raise_action_on_unpermitted_parameters
      ActionController::Parameters.action_on_unpermitted_parameters = :raise
      yield
    ensure
      ActionController::Parameters.action_on_unpermitted_parameters = :log
    end

    # permit only certain params for find and filtering appointments
    def find_appointments_params
      params.permit(:past, :page, :length)
    end

    # permit only certain params for creating new appointment
    def create_new_appointment_params
      params.permit(:start_time, :duration_in_minutes, patient: [:name], doctor: [:id])
    end
  end
end
