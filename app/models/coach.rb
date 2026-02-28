class Coach < ApplicationRecord
  belongs_to :zone
  has_many :bookings

  enum status: { active: "active", inactive: "inactive" }

  validates :name, :zone, :start_time, :end_time, presence: true
end

