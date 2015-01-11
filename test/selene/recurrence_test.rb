require 'test_helper'
require 'selene/recurrence'

module Selene
  class RecurrenceTest < MiniTest::Test
    TIME_FORMAT = '%F %T'

    def setup
      @start = Time.parse('2011-06-11 17:00:00')
    end
    # DTSTART;TZID=US-Eastern:19970902T090000
    # RRULE:FREQ=SECONDLY
    def test_can_calculate_secondly_recurrences
      recurrence = Recurrence.new(dtstart: @start, frequency: :secondly)

      assert_occurrences recurrence,
        '2011-06-11 17:00:00',
        '2011-06-11 17:00:01',
        '2011-06-11 17:00:02'
    end

    # DTSTART;TZID=US-Eastern:19970902T090000
    # RRULE:FREQ=MINUTELY
    def test_can_calculate_minutely_recurrences
      recurrence = Recurrence.new(dtstart: @start, frequency: :minutely)

      assert_occurrences recurrence,
        '2011-06-11 17:00:00',
        '2011-06-11 17:01:00',
        '2011-06-11 17:02:00'
    end

    # DTSTART;TZID=US-Eastern:19970902T090000
    # RRULE:FREQ=HOURLY
    def test_can_calculate_hourly_recurrences
      recurrence = Recurrence.new(dtstart: @start, frequency: :hourly)

      assert_occurrences recurrence,
        '2011-06-11 17:00:00',
        '2011-06-11 18:00:00',
        '2011-06-11 19:00:00'
    end

    # DTSTART;TZID=US-Eastern:19970902T090000
    # RRULE:FREQ=DAILY
    def test_can_calculate_daily_recurrences
      recurrence = Recurrence.new(dtstart: @start, frequency: :daily)

      assert_occurrences recurrence,
        '2011-06-11 17:00:00',
        '2011-06-12 17:00:00'
        '2011-06-13 17:00:00'
    end

    # DTSTART;TZID=US-Eastern:19970902T090000
    # RRULE:FREQ=WEEKLY
    def test_can_calculate_weekly_recurrences
      recurrence = Recurrence.new(dtstart: @start, frequency: :weekly)

      assert_occurrences recurrence,
        '2011-06-11 17:00:00',
        '2011-06-18 17:00:00'
        '2011-06-25 17:00:00'
    end

    # DTSTART;TZID=America/Detroit:20110611T170000
    # RRULE:FREQ=MONTHLY
    def test_can_calculate_monthly_recurrences
      recurrence = Recurrence.new(dtstart: @start, frequency: :monthly)

      assert_occurrences recurrence,
        '2011-06-11 17:00:00',
        '2011-07-11 17:00:00',
        '2011-08-11 17:00:00'
    end

    def test_can_recur_n_times
      recurrence = Recurrence.new(dtstart: @start, count: 10, frequency: :daily)
      assert_equal 10, recurrence.occurrences.count
    end

    private
    def assert_occurrences(recurrence, *expected_occurrences)
      recurrence.occurrences.take(expected_occurrences.count).each_with_index do |occurrence, index|
        assert_equal Time.parse(expected_occurrences.fetch(index)), occurrence
      end
    end
  end
end
