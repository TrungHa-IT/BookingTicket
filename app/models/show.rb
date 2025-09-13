class Show < ApplicationRecord
  belongs_to :movie
  belongs_to :room
  belongs_to :cinema

  has_many :show_time_details, dependent: :destroy
  has_many :bookings, dependent: :destroy

  # Validations
  validates :ticket_price, presence: true, numericality: { greater_than: 0 }
  validates :show_day, presence: true
end