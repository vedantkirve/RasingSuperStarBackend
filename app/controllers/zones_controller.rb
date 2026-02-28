class ZonesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def create
    zone = Zones::CreateZone.call(zone_params)

    render json: {
      success: true,
      data: zone
    }, status: :created
  end

  def index
    zones = Zones::ListZones.call

    render json: {
      success: true,
      data: zones
    }, status: :ok
  end

  private

  def zone_params
    params.require(:zone).permit(:name, :description, :status)
  end
end