class CoachesController < ApplicationController
  def create
    result = Coaches::CreateCoach.call(coach_params)

    render json: {
      success: true,
      data: result
    }, status: :created
  end

  private

  def coach_params
    params.require(:coach).permit(:name, :email, :phone_number, :zone_id, :start_time, :end_time, :status)
  end
end
