FactoryBot.define do
  factory :patient do
    doctor { create(:doctor) }
    name { Faker::Name.unique.name }
  end
end
