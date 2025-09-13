class SeatShowTimeDetail < ApplicationRecord
  belongs_to :show_time_detail
  belongs_to :seat

  # Validations
  validates :status, presence: true, inclusion: { in: ["Available", "Booked", "Held"] }

  # Một seat trong 1 show_time_detail chỉ được có 1 record
  validates :seat_id, uniqueness: { scope: :show_time_detail_id,
                                    message: "Ghế này đã tồn tại trong suất chiếu" }
end