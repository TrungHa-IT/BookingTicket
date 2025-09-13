class ShowTimeDetail < ApplicationRecord
  belongs_to :show
  has_many :booking_seats, dependent: :destroy
  has_many :seat_show_time_details, dependent: :destroy

  # Validations
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate  :end_time_after_start_time

  # Scopes
  scope :by_show, ->(show_id) { where(show_id: show_id) if show_id.present? }
  scope :sorted, ->(sort) {
    if sort.present?
      if sort.start_with?('-')
        order("#{sort[1..]} DESC")
      else
        order("#{sort} ASC")
      end
    else
      order(created_at: :desc)
    end
  }

  private

  def end_time_after_start_time
    if start_time.present? && end_time.present? && end_time <= start_time
      errors.add(:end_time, "phải lớn hơn start_time")
    end
  end
end
