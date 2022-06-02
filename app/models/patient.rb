# For this test app, you can assume a patient has only one doctor
class Patient < ApplicationRecord
  validates :name, uniqueness: true
  belongs_to :doctor
  has_many :appointments
end
