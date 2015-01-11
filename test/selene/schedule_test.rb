require 'test_helper'
require 'selene/schedule'

module Selene
  class ScheduleTest < MiniTest::Test
    def test_calculates_duration_from_end_time
      start_time = Time.parse('2011-06-11 17:00')
      end_time = Time.parse('2011-06-11 18:00')
      schedule = Schedule.new(start_time, end_time: end_time)
      assert_equal end_time - start_time, schedule.duration
    end

    def test_calculates_end_time_from_duration
      start_time = Time.parse('2011-06-11 17:00')
      duration = 60 * 60
      schedule = Schedule.new(start_time, duration: duration)
      assert_equal start_time + duration, schedule.end_time
    end

    def test_can_recur_n_times
      start_time = Time.parse('2011-06-11 17:00')
      schedule = Schedule.new(start_time, duration: 60 * 60, count: 10)
      assert_equal 10, schedule.occurrences.count
    end
  end
end
