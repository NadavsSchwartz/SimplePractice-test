FactoryBot.define do
  factory :doctor do
    name { Faker::Name.unique.name }
  end
end
