class Plan < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :yearly_price, presence: true

  has_many :orders
end
