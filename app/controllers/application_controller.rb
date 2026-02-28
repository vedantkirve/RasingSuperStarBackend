class ApplicationController < ActionController::API
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable
  rescue_from StandardError, with: :handle_internal_error

  private

  def authenticate_user!
    true
  end

  def handle_not_found(error)
    render json: { success: false, error: error.message }, status: :not_found
  end

  def handle_unprocessable(error)
    render json: { success: false, error: error.message }, status: :unprocessable_entity
  end

  def handle_internal_error(error)
    render json: { success: false, error: error.message }, status: :internal_server_error
  end
end