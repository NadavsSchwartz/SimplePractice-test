# frozen_string_literal: true

module Api
  class DoctorsController < ApplicationController
    def index
      @doctors = Doctor.all.select { |doctor| doctor.appointments.empty? }

      if @doctors.empty?
        render json: { message: 'All doctors currerntly have appointments' }
      else
        render json: @doctors
      end
    end
  end
end
