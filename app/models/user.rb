class User < ApplicationRecord
  validates :cpf, presence: true,
                  uniqueness: true,
                  length: { maximum: 11 }

  validates :email, presence: true,
                    uniqueness: true,
                    length: { maximum: 60 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :name, presence: true

  validates_with CpfValidator
end
