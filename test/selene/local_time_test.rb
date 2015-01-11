require 'test_helper'
require 'selene/local_time'

class LocalTimeTest < MiniTest::Test
  def test_to_time
    assert_equal Time.parse('2011-06-11 17:00:00'), LocalTime.new(2011, 06, 11, 17, 0, 0).to_time
  end

  def test_from_time
    time = Time.parse('2011-06-11 17:00:00')
    assert_equal [2011, 06, 11, 17, 0, 0], LocalTime.from_time(time).to_a
  end

  def test_add_day
    local_time = LocalTime.new(2011, 06, 11, 17, 0, 0).add(1, :day)
    assert_equal Time.parse('2011-06-12 17:00:00'), local_time.to_time
  end

  def test_subtract_day
    local_time = LocalTime.new(2011, 06, 11, 17, 0, 0).subtract(1, :day)
    assert_equal Time.parse('2011-06-10 17:00:00'), local_time.to_time
  end

  def test_add_week
    local_time = LocalTime.new(2011, 06, 11, 17, 0, 0).add(1, :week)
    assert_equal Time.parse('2011-06-18 17:00:00'), local_time.to_time
  end

  def test_unknown_part
    exception = assert_raises LocalTime::UnknownPart do
      LocalTime.new(2011, 06, 11, 17, 0, 0).add(1, :microsecond)
    end
    assert_equal "Did not recognize 'microsecond'", exception.message
  end

  def test_handles_month_overflow
    local_time = LocalTime.new(2011, 06, 11, 17, 0, 0).add(7, :month)
    assert_equal [2011, 13, 11, 17, 0, 0], local_time.to_a
    assert_equal Time.parse('2012-1-11 17:00:00'), local_time.to_time

    local_time = LocalTime.new(2011, 06, 11, 17, 0, 0).subtract(6, :month)
    assert_equal [2011, 0, 11, 17, 0, 0], local_time.to_a
    assert_equal Time.parse('2010-12-11 17:00:00'), local_time.to_time
  end

  # When given an arbitrary integer, what day should we pass to Time.new?
  def test_num_in_range
    test = ->(num) { LocalTime.num_in_range(num, 1..31) }
    assert_equal 1, test.(-1) # January 1st
    assert_equal 1, test.(0) # January 1st
    assert_equal 1, test.(1) # January 1st
    assert_equal 31, test.(31) # January 31st
    assert_equal 31, test.(32) # January 31st
    assert_equal 31, test.(33) # January 31st
  end

  # When given an arbitrary integer, how many days do we have to add/subtract to get to the right date?
  def test_num_modulo_range
    test = ->(num) { LocalTime.num_modulo_range(num, 1..31) }
    assert_equal -2, test.(-1) # 2 days before
    assert_equal -1, test.(0) # 1 day before
    assert_equal 0, test.(1) # today
    assert_equal 0, test.(31) # today
    assert_equal 1, test.(32) # 1 day after 
    assert_equal 2, test.(33) # 2 days after
  end

  # When given an arbitrary integer, how can we interpret the date in the correct local time?
  def test_sum_of_num_in_range_and_num_modulo_range
    test = ->(num) { LocalTime.num_in_range(num, 1..31) + LocalTime.num_modulo_range(num, 1..31) }

    assert_equal 1 - 2, test.(-1) # 2 days before January 1st
    assert_equal 1 - 1, test.(0) # 1 day before January 1st
    assert_equal 1 - 0, test.(1) # January 1st
    assert_equal 31 + 0, test.(31) # January 31st
    assert_equal 31 + 1, test.(32) # 1 day after January 31st
    assert_equal 31 + 2, test.(33) # 2 days after January 31st
  end

  def test_num_cycle_range
    test = ->(num) { LocalTime.num_cycle_range(num, 1..12) }

    assert_equal 11, test.(-1)
    assert_equal 12, test.(0)
    assert_equal 1, test.(1)
    assert_equal 12, test.(12)
    assert_equal 1, test.(13)
    assert_equal 2, test.(14)
  end

  def test_num_cycle_offset_range
    test = ->(num) { LocalTime.num_cycle_offset_range(num, 1..12) }

    assert_equal -2, test.(-12), -12 # 2 years ago, December
    assert_equal -1, test.(-11), -11 # 1 year ago, January
    assert_equal -1, test.(0) # 1 year ago, December
    assert_equal 0, test.(1), 1 # this year, January
    assert_equal 0, test.(12), 12 # this year, December
    assert_equal 1, test.(13), 13 # 1 year from now, January
    assert_equal 1, test.(23), 23 # 1 year from now, December
    assert_equal 2, test.(24), 24 # 2 years from now, January
  end
end
