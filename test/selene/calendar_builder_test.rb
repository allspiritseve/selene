require 'test_helper'

module Selene
  class CalendarBuilderTest < TestCase

    def builder
      @builder ||= CalendarBuilder.new
    end

    def event_builder
      @event_builder ||= EventBuilder.new.extend(Stubbable)
    end

    def time_zone_builder
      @time_zone_builder ||= TimeZoneBuilder.new.extend(Stubbable)
    end

    def test_parse_prodid
      builder.parse('PRODID', '', '-//Meetup//RemoteApi//EN')
      assert_equal builder.component['prodid'], '-//Meetup//RemoteApi//EN'
    end

    def test_parse_version
      builder.parse('VERSION', '', '2.0')
      assert_equal @builder.component['version'], '2.0'
    end

    def test_parse_calscale
      builder.parse('CALSCALE', '', 'Gregorian')
      assert_equal builder.component['calscale'], 'Gregorian'
    end

    def test_parse_method
      builder.parse('METHOD', '', 'Publish')
      assert_equal builder.component['method'], 'Publish'
    end

    def test_parse_x_prop
      builder.parse('X-ORIGINAL-URL', '', 'http://www.google.com')
      assert_equal builder.component['x-original-url'], 'http://www.google.com'
    end

    def test_append_event_builder
      event_builder.stub :component, { 'summary' => "Bluth's Best Party" }
      builder.append(event_builder)
      assert_equal builder.component['events'].first['summary'], "Bluth's Best Party"
    end

    def test_append_time_zone_builder
      time_zone_builder.stub :component, { 'tzid' => 'America/Detroit' }
      builder.append(time_zone_builder)
      assert_equal builder.component['time_zones'].first, { 'tzid' => 'America/Detroit' }
    end

  end
end
