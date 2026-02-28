class AvailabilityController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    availability = Availability::GetZoneAvailability.call(params[:zone_id])

    render json: {
      success: true,
      availability: availability
    }
  end
end
