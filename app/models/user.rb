class User < ApplicationRecord
  has_many :bookings

  enum :status, { active: "active", inactive: "inactive" }

  validates :name, presence: true
end

