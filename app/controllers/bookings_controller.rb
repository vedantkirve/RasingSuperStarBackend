class BookingsController < ApplicationController
  def create
    result = Bookings::CreateBooking.call(booking_params)

    render json: {
      success: true,
      data: result
    }, status: :created
  end

  private

  def booking_params
    params.require(:booking).permit(:user_id, :zone_id, :session_date, :start_time)
  end
end
