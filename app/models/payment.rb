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

  # Scopes
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_payment_method, ->(method) { where(payment_method: method) if method.present? }
  scope :search, ->(q) {
    if q.present?
      pattern = "%#{ActiveRecord::Base.sanitize_sql_like(q)}%"
      joins(booking: :user).where("users.fullname LIKE ?", pattern)
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
