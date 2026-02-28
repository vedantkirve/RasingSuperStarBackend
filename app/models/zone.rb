class Zone < ApplicationRecord
  has_many :coaches

  enum :status, { active: "active", inactive: "inactive" }, validate: true
  validates :name, presence: true, uniqueness: true
end

