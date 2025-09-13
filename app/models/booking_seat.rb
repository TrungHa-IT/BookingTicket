class BookingSeat < ApplicationRecord
  belongs_to :booking
  belongs_to :seat
  belongs_to :show_time_detail

  # Validations
  validates :hold_still, inclusion: { in: [true, false] }
end