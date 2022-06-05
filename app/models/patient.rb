# frozen_string_literal: true

# For this test app, you can assume a patient has only one doctor
class Patient < ApplicationRecord
  validates :name, uniqueness: true
  # has_one :doctor
  belongs_to :doctor
  has_many :appointments
end
