class Transaction < ApplicationRecord
  belongs_to :invoice
  has_many :customers, through: :invoice
  has_many :items, through: :invoice
  # enum result: [:failed, :success]
end
