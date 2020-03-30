FactoryBot.define do
  factory :order do
    device_imei { "498085305623365" }
    device_model { Faker::Device.model_name }
    installments { Faker::Number.digit }
    plan
    user
  end
end
