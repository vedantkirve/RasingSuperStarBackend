module Availability
  class GetZoneAvailability
    def self.call(zone_id)
      new(zone_id).call
    end

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def call
      coaches = Coach.where(zone_id: @zone_id, status: "active")
      return [] if coaches.empty?

      today = Time.zone.today
      date_range = today..(today + 6)
      coach_ids = coaches.pluck(:id)

      bookings = Booking.where(
        coach_id: coach_ids,
        session_date: date_range,
        state: "confirmed",
        status: "active"
      )

      booked_slots_by_date_and_coach = build_booked_slots_map(bookings)

      availability_by_date = {}
      date_range.each do |date|
        available_slots = available_slots_for_date(date, coach_ids, booked_slots_by_date_and_coach)
        availability_by_date[date] = available_slots if available_slots.any?
      end

      availability_by_date.sort.map do |date, slots|
        {
          date: date.strftime("%Y-%m-%d"),
          slots: slots.sort_by { |s| s[:start_time] }
        }
      end
    end

    private

    def build_booked_slots_map(bookings)
      map = Hash.new { |h, k| h[k] = Hash.new { |h2, k2| h2[k2] = Set.new } }
      bookings.each do |booking|
        slot_key = booking.start_time.strftime("%H:%M")
        map[booking.session_date][booking.coach_id].add(slot_key)
      end
      map
    end

    def available_slots_for_date(date, coach_ids, booked_slots_by_date_and_coach)
      available_slot_starts = Set.new

      coach_ids.each do |coach_id|
        booked_for_coach = booked_slots_by_date_and_coach[date][coach_id]
        BOOKING_TIME_SLOTS.each do |slot|
          slot_start = slot[:start_time]
          available_slot_starts.add(slot_start) unless booked_for_coach.include?(slot_start)
        end
      end

      available_slot_starts.map do |start_time|
        slot = BOOKING_TIME_SLOTS.find { |s| s[:start_time] == start_time }
        { start_time: slot[:start_time], end_time: slot[:end_time] }
      end
    end
  end
end
