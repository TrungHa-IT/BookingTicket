class Booking < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :show

  has_one :payment, dependent: :destroy
  has_many :booking_seats, dependent: :destroy
  has_many :seats, through: :booking_seats
  
  # Validations
  validates :user_id, presence: true
  validates :show_id, presence: true
  validates :booking_time, presence: true
  validates :total_amount, presence: true,
                           numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :by_user, ->(user_id) { where(user_id: user_id) if user_id.present? }
  scope :by_show, ->(show_id) { where(show_id: show_id) if show_id.present? }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :search, ->(q) {
    if q.present?
      pattern = "%#{ActiveRecord::Base.sanitize_sql_like(q)}%"
      joins(:user).where("users.fullname LIKE ?", pattern)
    end
  }
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
end
