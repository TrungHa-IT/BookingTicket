class Booking < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :show

  has_one :payment, dependent: :destroy
  has_many :booking_seats, dependent: :destroy

  # Validations
  validates :user_id, presence: true
  validates :show_id, presence: true
  validates :booking_time, presence: true
  validates :total_amount, presence: true,
                           numericality: { greater_than_or_equal_to: 0 }
end