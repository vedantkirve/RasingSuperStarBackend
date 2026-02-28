module Zones
  class ListZones
    def self.call
      Zone.where(status: "active")
    end
  end
end