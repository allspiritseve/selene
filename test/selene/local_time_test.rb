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
  end
end
