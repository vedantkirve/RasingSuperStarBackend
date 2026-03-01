module Users
  class CreateUser
    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params.to_h.with_indifferent_access
    end

    def call
      validate_required_fields!
      ActiveRecord::Base.transaction do
        user = User.create!(user_attributes)
        user
      end
    end

    private

    def validate_required_fields!
      return if @params[:name].present? && @params[:phone_number].present?

      user = User.new
      user.errors.add(:name, "can't be blank") if @params[:name].blank?
      user.errors.add(:phone_number, "can't be blank") if @params[:phone_number].blank?
      raise ActiveRecord::RecordInvalid, user if user.errors.any?
    end

    def user_attributes
      {
        name: @params[:name],
        email: @params[:email].presence,
        phone_number: @params[:phone_number],
        status: @params[:status].presence || "active"
      }
    end
  end
end
