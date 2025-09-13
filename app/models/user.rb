class User < ApplicationRecord
  # Associations
  has_many :bookings, dependent: :destroy

  # Validations
  validates :fullname, presence: true, length: { maximum: 100 }
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "không đúng định dạng" }
  validates :phone, presence: true, uniqueness: true,
                    format: { with: /\A[0-9]{9,11}\z/, message: "phải là số từ 9-11 chữ số" }
  validates :password_hash, presence: true, length: { minimum: 6 }
  validates :role, presence: true,
                   inclusion: { in: [0, 1], message: "chỉ được 0 (user) hoặc 1 (admin)" }

  # Scopes
  scope :by_role, ->(role) { where(role: role) if role.present? }
  scope :search, ->(q) {
    if q.present?
      pattern = "%#{ActiveRecord::Base.sanitize_sql_like(q)}%"
      where("fullname LIKE ? OR email LIKE ? OR phone LIKE ?", pattern, pattern, pattern)
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
