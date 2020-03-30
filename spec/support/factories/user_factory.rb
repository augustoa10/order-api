FactoryBot.define do
  factory :user do
    id { Faker::Number.digit }
    name { Faker::Name.first_name }
    cpf { Faker::IDNumber.brazilian_citizen_number }
    email { Faker::Internet.email }
  end
end
