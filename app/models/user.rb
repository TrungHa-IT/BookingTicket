class User < ApplicationRecord
  # Associations
  has_many :bookings, class_name: "Booking", foreign_key: "userId", dependent: :destroy

  # VALIDATIONS
  validates :fullname, presence: true, length: { maximum: 100 }

  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "không đúng định dạng" }

  validates :phone, presence: true, uniqueness: true,
                    format: { with: /\A[0-9]{9,11}\z/, message: "phải là số từ 9-11 chữ số" }

  validates :password_hash, presence: true, length: { minimum: 6 }

  validates :role, presence: true,
                   inclusion: { in: [0, 1], message: "chỉ được 0 (user) hoặc 1 (admin)" }
end