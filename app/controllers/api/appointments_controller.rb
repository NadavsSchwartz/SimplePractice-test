# frozen_string_literal: true

module Api
  class AppointmentsController < ApplicationController
    has_scope :past, type: :boolean
    has_scope :page, type: :integer
    has_scope :length, type: :integer
    ActionController::Parameters.action_on_unpermitted_parameters = :raise
    rescue_from ActionController::UnpermittedParameters, with: :render_unpermitted_params_response
    def index
      #get all params
    
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
    def render_unpermitted_params_response
      render json: { "Unpermitted Parameters": params.to_unsafe_h.except(:controller, :action, :past, :page, :length).keys }, status: :unprocessable_entity
  end
  end
end
