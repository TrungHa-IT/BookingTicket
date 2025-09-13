class ShowTimeDetail < ApplicationRecord
  belongs_to :show
  has_many :booking_seats, dependent: :destroy

  # Validations
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate  :end_time_after_start_time

  private

  def end_time_after_start_time
    if start_time.present? && end_time.present? && end_time <= start_time
      errors.add(:end_time, "phải lớn hơn start_time")
    end
  end
end