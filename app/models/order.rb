class Order < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  validates :device_imei, presence: true, uniqueness: true
  validates :device_model, presence: true
  validates :installments, presence: true

  validates_with ImeiValidator
end
