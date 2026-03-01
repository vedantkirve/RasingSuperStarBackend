# frozen_string_literal: true

# Shared config for coaching session time slots (90 minutes each).
# Used by availability API and booking creation.
BOOKING_TIME_SLOTS = [
  { start_time: "10:00", end_time: "11:30" },
  { start_time: "11:30", end_time: "13:00" },
  { start_time: "13:00", end_time: "14:30" },
  { start_time: "14:30", end_time: "16:00" },
  { start_time: "16:00", end_time: "17:30" },
  { start_time: "17:30", end_time: "19:00" }
].freeze

VALID_BOOKING_START_TIMES = BOOKING_TIME_SLOTS.map { |s| s[:start_time] }.freeze
