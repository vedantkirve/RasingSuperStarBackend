module Coaches
  class CreateCoach
    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params.to_h.with_indifferent_access
    end

    def call
      validate_required_fields!
      ActiveRecord::Base.transaction do
        zone = Zone.find(@params[:zone_id])
        coach = Coach.create!(coach_attributes.merge(zone: zone))
        coach
      end
    end

    private

    def validate_required_fields!
      coach = Coach.new
      coach.errors.add(:name, "can't be blank") if @params[:name].blank?
      coach.errors.add(:phone_number, "can't be blank") if @params[:phone_number].blank?
      coach.errors.add(:zone_id, "can't be blank") if @params[:zone_id].blank?
      coach.errors.add(:start_time, "can't be blank") if @params[:start_time].blank?
      coach.errors.add(:end_time, "can't be blank") if @params[:end_time].blank?
      raise ActiveRecord::RecordInvalid, coach if coach.errors.any?
    end

    def coach_attributes
      {
        name: @params[:name],
        email: @params[:email].presence,
        phone_number: @params[:phone_number],
        start_time: parse_time(@params[:start_time]),
        end_time: parse_time(@params[:end_time]),
        status: @params[:status].presence || "active"
      }
    end

    def parse_time(value)
      return value if value.blank?
      return value if value.is_a?(Time) || value.is_a?(ActiveSupport::TimeWithZone)

      str = value.to_s.strip
      return nil if str.blank?

      Time.zone.parse("2000-01-01 #{str}")&.to_time
    end
  end
end
