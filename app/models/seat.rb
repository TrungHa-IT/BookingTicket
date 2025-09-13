class Seat < ApplicationRecord
  belongs_to :room

  has_many :booking_seats, dependent: :destroy

  # Validations
  validates :seat_number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :seat_row, presence: true, length: { maximum: 5 }   # Ví dụ: "A", "B", "C" hoặc "AA"
  validates :room_id, presence: true

  # Một ghế trong cùng phòng thì không được trùng seat_row + seat_number
  validates :seat_number, uniqueness: { scope: [:seat_row, :room_id],
                                        message: "Ghế đã tồn tại trong phòng" }
end