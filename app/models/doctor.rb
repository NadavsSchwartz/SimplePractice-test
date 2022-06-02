class Doctor < ApplicationRecord
  validates :name, uniqueness: true
  has_many :patients
  has_many :appointments
end
