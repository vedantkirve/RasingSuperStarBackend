class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    result = Users::CreateUser.call(user_params)

    render json: {
      success: true,
      data: result
    }, status: :created
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone_number, :status)
  end
end
