class Api::AppointmentsController < ApplicationController
	has_scope :past, type: :boolean, using: %i[past], type: :hash

	has_scope :page, type: :integer, using: %i[page], type: :hash
	def index
		# if params exist, use it to filter appointments
		if (params[:past])
			@appointments = Appointment.past(params[:past])
		elsif (params[:page] && params[:length])
			@appointments = Appointment.page(params[:page], params[:length])
		else
			# if params doesn't exists, return all appointments
			@appointments = Appointment.all
		end
		return render json: join_tables_and_modify_response(@appointments)
	end

	def create
		# TODO:
	end

	private

	def join_tables_and_modify_response(appointments)
		return(
			appointments
				.joins(:patient, :doctor)
				.select(
					'appointments.*, patients.name as patient_name, patients.id as patient_id, doctors.name as doctor_name, doctors.id as doctor_id',
				)
				.map do |appointment|
					{
						id: appointment.id,
						patient: {
							name: appointment.patient_name,
						},
						doctor: {
							name: appointment.doctor_name,
							id: appointment.doctor_id,
						},
						created_at: appointment.created_at.iso8601,
						start_time: appointment.start_time.iso8601,
						duration_in_minutes: appointment.duration_in_minutes,
					}
				end
		)
	end
end
