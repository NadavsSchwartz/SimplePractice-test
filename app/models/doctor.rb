# frozen_string_literal: true

class Doctor < ApplicationRecord
  scope :available, lambda { |date|
    where(id: Appointment.where('start_time > ?', date))
  }
  validates :name, uniqueness: true
  has_many :patients
  has_many :appointments
end
