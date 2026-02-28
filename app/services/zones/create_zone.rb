module Zones
  class CreateZone
    def self.call(params)
      ActiveRecord::Base.transaction do
        zone = Zone.create!(params)
        zone
      end
    end
  end
end