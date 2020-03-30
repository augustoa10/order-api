FactoryBot.define do
  factory :plan do
    id { Faker::Number.digit }
    name { Faker::Subscription.plan }
    description { Faker::Lorem.sentence }
    yearly_price { Faker::Number.decimal(l_digits: 2) }
  end
end
