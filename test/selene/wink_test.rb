require 'test_helper'
require 'selene'

module Selene
  module SunTimeExtensions
    def value(line)
      case line.name
      when 'x-wink-ststart', 'x-wink-stend'
        line.values
      else
        super
      end
    end
  end

  EventBuilder.send(:include, SunTimeExtensions)
end

module Selene
  class WinkTest < MiniTest::Test
    def setup
      @ical = "DTSTART;TZID=America/Detroit:20140919T065100\nX-WINK-STSTART:sunrise;42.2814;-83.7483\nDTEND;TZID=America/Detroit:20140918T190900\nX-WINK-STEND:sunset;42.2814;-83.7483\nRRULE:FREQ=DAILY\nEXDATE;TZID=America/Detroit:20140929T065100,20140930T065100"
    end

    def test_parses_string_line
      component = EventBuilder.parse({}, 'DTSTART;TZID=America/Detroit:20140919T065100')
      assert_equal component.fetch('dtstart'), ['20140919T065100', { 'tzid' => 'America/Detroit' }]
    end

    def test_parses_multiple_string_lines
      component = EventBuilder.parse({}, @ical)
      assert_equal component['dtstart'], ['20140919T065100', { 'tzid' => 'America/Detroit' }]
      assert_equal component['dtend'], ['20140918T190900', { 'tzid' => 'America/Detroit' }]
      assert_equal component['rrule'], { 'freq' => 'DAILY' }
      assert_equal component['x-wink-ststart'], ['sunrise', '42.2814', '-83.7483']
      assert_equal component['x-wink-stend'], ['sunset', '42.2814', '-83.7483']
      assert_equal component['exdate'], [['20140929T065100', '20140930T065100'], { 'tzid' => 'America/Detroit' }]
    end

    def test_can_convert_back_to_ical
      component = EventBuilder.parse({}, @ical)
      ical = EventBuilder.to_ical(component)
      assert_equal ical, @ical
    end

    def test_can_update_datetimes
      builder = EventBuilder.new('vevent')
      builder.parse(@ical)
      now = Time.now
      component = builder.update_properties('dtstart' => now)
      assert_equal component['dtstart'], [now.strftime('%Y%m%dT%H%M%S'), { 'tzid' => 'America/Detroit' }]
    end

    # private
    # def builder
    #   @builder ||= EventBuilder.new('vevent')
    # end
  end
end
