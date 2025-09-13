class Payment < ApplicationRecord
  # Associations
  belongs_to :booking

  # Validations
  validates :payment_method, presence: true
  validates :amount, presence: true,
                     numericality: { greater_than: 0 }
  validates :payment_date, presence: true
  validates :status, presence: true,
                     inclusion: { in: ["Success", "Pending", "Failed"] }
end