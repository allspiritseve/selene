require 'test_helper'
require 'selene/line'
require 'selene/duration'

module Selene
  class ValueBuilder
  end

  class RecurValueBuilder < ValueBuilder
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

    def parse(line)
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
  end

  class ValueBuilder
  end

  class GeoValueBuilder < ValueBuilder
    def parse(line)
      line.value.split(';').map(&:to_f)
    end

    def serialize(value)
      value.join(';')
    end
  end

  class DurationValueBuilder < ValueBuilder
    def self.parse(duration)
      duration.to_s.scan(/\d+[WDHMS]/).inject(0) do |total, part|
        total + parse_part(part)
      end * sign(duration)
    end

    def self.parse_part(part)
      Duration.send(unit(part), number(part))
    end

    def self.unit(part)
      Duration::UNITS.detect { |unit| unit =~ /^#{part[-1]}/i }
    end

    def self.number(part)
      part[0...-1].to_i
    end

    def self.sign(duration)
      duration.match(/^-/) ? -1 : 1
    end

    def serialize(duration)
      parts = [60, 60, 24, 7, 1].map do |denominator|
        n = duration % denominator
        duration = duration / denominator
        n
      end

      all_parts = parts.zip(%w(S M H D W)).reverse
      result = ['P']
      result << all_parts[0..1].reject { |n, unit| n == 0 }
      result << 'T' if all_parts[2..-1].any? { |n, _| n > 0 }
      result << all_parts[2..-1].reject { |n, unit| n == 0 }
      result.join
    end
  end

  class ValueBuilderTest < MiniTest::Test
    def test_recur_property
      builder = RecurValueBuilder.new
      line = Line.new('RRULE', 'FREQ=YEARLY;INTERVAL=2;BYMONTH=1;BYDAY=SU;BYHOUR=8,9;BYMINUTE=30')
      actual = builder.parse(line)
      expected = { 'FREQ' => 'YEARLY', 'INTERVAL' => 2, 'BYMONTH' => [1], 'BYDAY' => ['SU'], 'BYHOUR' => [8, 9], 'BYMINUTE' => [30] }
      assert_equal expected, actual

      actual = builder.parse(Line.new('RRUKE', 'BYDAY=1MO,-2TU,TH'))
      expected = { 'BYDAY' => [[1, 'MO'], [-2, 'TU'], 'TH'] }
      assert_equal actual, expected
    end

    def test_geo_property
      builder = GeoValueBuilder.new
      line = Line.new('GEO', '42.33;-83.05')
      expected = [42.33, -83.05]
      actual = builder.parse(line)
      assert_equal expected, actual

      actual = builder.serialize(actual)
      assert_equal line.value, actual
    end

    def test_duration_value
      assert_equal (60 * 60), DurationValueBuilder.parse('PT1H')
      assert_equal (60 * 60) + (30 * 60), DurationValueBuilder.parse('PT1H30M')
      assert_equal (24 * 60 * 60) + (60 * 60) + (30 * 60) + 30, DurationValueBuilder.parse('P1DT1H30M30S')
      assert_equal (7 * 24 * 60 * 60), DurationValueBuilder.parse('P1W')
      assert_equal (-1 * 60 * 60), DurationValueBuilder.parse('-PT1H')
    end

    def test_duration_unit
      assert_equal :weeks, DurationValueBuilder.unit('W')
      assert_equal :days, DurationValueBuilder.unit('D')
      assert_equal :hours, DurationValueBuilder.unit('H')
      assert_equal :minutes, DurationValueBuilder.unit('M')
      assert_equal :seconds, DurationValueBuilder.unit('S')

      assert_equal 7 * 24 * 60 * 60, DurationValueBuilder.parse_part('1W')
      assert_equal 24 * 60 * 60, DurationValueBuilder.parse_part('1D')
      assert_equal 60 * 60, DurationValueBuilder.parse_part('1H')
      assert_equal 60, DurationValueBuilder.parse_part('1M')
      assert_equal 1, DurationValueBuilder.parse_part('1S')
    end

    def test_duration_serialize
      builder = DurationValueBuilder.new
      assert_equal 'PT1H', builder.serialize(60 * 60)
    end
  end
end
