module Bookings
  class CreateBooking
    def self.call(params)
      new(params).call
    end

    def initialize(params)
      @params = params.to_h.with_indifferent_access
    end

    def call
      validate_required_fields!
      user = User.find(@params[:user_id])
      zone = Zone.find(@params[:zone_id])
      session_date = parse_date(@params[:session_date])
      start_time = parse_time(@params[:start_time])

      ActiveRecord::Base.transaction do
        coach = find_available_coach(zone.id, session_date, start_time)

        if coach.nil?
          booking = Booking.new(
            user_id: user.id,
            session_date: session_date,
            start_time: start_time
          )
          booking.errors.add(:base, "No coach available for the requested slot")
          raise ActiveRecord::RecordInvalid, booking
        end

        end_time = start_time + 90.minutes
        Booking.create!(
          coach_id: coach.id,
          user_id: user.id,
          session_date: session_date,
          start_time: start_time,
          end_time: end_time,
          state: "confirmed",
          status: "active"
        )
      end
    end

    private

    def validate_required_fields!
      booking = Booking.new
      booking.errors.add(:user_id, "can't be blank") if @params[:user_id].blank?
      booking.errors.add(:zone_id, "can't be blank") if @params[:zone_id].blank?
      booking.errors.add(:session_date, "can't be blank") if @params[:session_date].blank?
      booking.errors.add(:start_time, "can't be blank") if @params[:start_time].blank?
      raise ActiveRecord::RecordInvalid, booking if booking.errors.any?
    end

    def find_available_coach(zone_id, session_date, start_time)
      coaches = Coach.where(zone_id: zone_id, status: "active")
      return nil if coaches.empty?

      booked_coach_ids = Booking.where(
        coach_id: coaches.select(:id),
        session_date: session_date,
        start_time: start_time,
        state: "confirmed",
        status: "active"
      ).pluck(:coach_id)

      available_coaches = coaches.where.not(id: booked_coach_ids)
      return nil if available_coaches.empty?
      return available_coaches.first if available_coaches.one?

      pick_coach_with_least_bookings(available_coaches, session_date)
    end

    def pick_coach_with_least_bookings(coaches, session_date)
      coach_ids = coaches.pluck(:id)
      counts = Booking.where(
        coach_id: coach_ids,
        session_date: session_date
      ).group(:coach_id).count

      coaches.min_by { |c| counts[c.id] || 0 }
    end

    def parse_date(value)
      return value if value.is_a?(Date)
      return value.to_date if value.respond_to?(:to_date)

      Date.parse(value.to_s) if value.present?
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
