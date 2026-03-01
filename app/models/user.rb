class User < ApplicationRecord
  has_many :bookings

  enum :status, { active: "active", inactive: "inactive" }

  validates :name, :phone_number, presence: true
end

