class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :coach

  enum :status, { active: "active", inactive: "inactive" }
  enum :state, {
    confirmed: "confirmed",
    cancelled: "cancelled",
    completed: "completed"
  }, prefix: true

  validates :user, :coach, :session_date, :start_time, :end_time, presence: true
end

