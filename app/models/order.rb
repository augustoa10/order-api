class Order < ApplicationRecord

  validates_with ImeiValidator
end
