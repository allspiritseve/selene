require 'test_helper'
require 'selene/time_value'

class TimeValueTest < MiniTest::Test
  def setup
    @start = Time.parse('2011-06-11 17:00:00')
  end

  def test_add_day
    time = TimeValue.new(@start).add(1, :day).time
    assert_equal Time.parse('2011-06-12 17:00:00'), time
  end

  def test_subtract_day
    time = TimeValue.new(@start).subtract(1, :day).time
    assert_equal Time.parse('2011-06-10 17:00:00'), time
  end

  def test_add_week
    time = TimeValue.new(@start).add(1, :week).time
    assert_equal Time.parse('2011-06-18 17:00:00'), time
  end

  def test_unknown_part
    exception = assert_raises TimeValue::UnknownPartError do
      TimeValue.new(@start).add(1, :microsecond)
    end
    assert_equal "Did not recognize 'microsecond'", exception.message
  end
end
