FactoryBot.define do
  factory :device do
    id { Faker::Number.digit }
    name { Faker::Device.model_name }
  end
end
