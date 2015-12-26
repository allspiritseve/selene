require 'test_helper'
require 'selene/line'

class PropertyBuilder
  def unserialize(line)
    line.value.scan(/([^\;]+)=([^\;]+)/).inject({}) do |memo, (key, value)|
      memo.merge(key => parse_part(key, value))
    end
  end

  def parse_part(key, value)
    case key
    when 'COUNT', 'INTERVAL'
      value.to_i
    when /BY(SECOND|MINUTE|HOUR|MONTHDAY|YEARDAY|WEEKNO|MONTH)/
      value.split(/,/).map(&:to_i)
    when /BYDAY/
      value.split(',').map do |item|
        day = item[-2..-1]
        if item.length > 2
          occurrence = item[0..-2].to_i
          [occurrence, day]
        else
          day
        end
      end
    else
      value
    end
  end

  def serialize
  end
end

# +/- ordweek weekday

class RecurPropertyBuilder < PropertyBuilder
  # part 'FREQ', required: true, multiple: false
  # part 'UNTIL', multiple: false
  # part 'COUNT', multiple: false
  # part 'INTERVAL', multiple: false
  # part 'BYSECOND', multiple: false
  # part 'BYMINUTE', multiple: false
  # part 'BYHOUR', multiple: false
  # part 'BYDAY', multiple: false
  # part 'BYMONTHDAY', multiple: false
  # part 'BYYEARDAY', multiple: false
  # part 'BYWEEKNO', multiple: false
  # part 'BYMONTH', multiple: false
  # part 'BYSETPOS', multiple: false
  # part 'WKST', multiple: false
end

module Selene
  class PropertyBuilderTest < MiniTest::Test
    def test_recur_property
      builder = PropertyBuilder.new
      line = Line.new('RRULE', 'FREQ=YEARLY;INTERVAL=2;BYMONTH=1;BYDAY=SU;BYHOUR=8,9;BYMINUTE=30')
      actual = builder.unserialize(line)
      expected = { 'FREQ' => 'YEARLY', 'INTERVAL' => 2, 'BYMONTH' => [1], 'BYDAY' => ['SU'], 'BYHOUR' => [8, 9], 'BYMINUTE' => [30] }
      assert_equal expected, actual

      actual = builder.unserialize(Line.new('RRUKE', 'BYDAY=1MO,-2TU,TH'))
      expected = { 'BYDAY' => [[1, 'MO'], [-2, 'TU'], 'TH'] }
      assert_equal actual, expected
    end
  end
end
