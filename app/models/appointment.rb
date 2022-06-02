class Appointment < ApplicationRecord
	belongs_to :doctor
	belongs_to :patient

	scope :past,
	      ->(past) {
			if past == '1'
				@past_appointments = where('start_time > ?', Time.now)
			else
				@past_appointments = where('start_time < ?', Time.now)
			end
			@past_appointments
	      }

	scope :page,
	      ->(page, length) { limit(length).offset(page.to_i * length.to_i) }
end
