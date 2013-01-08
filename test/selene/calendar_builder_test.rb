require 'test_helper'

module Selene
  class CalendarBuilderTest < MiniTest::Unit::TestCase
    include BuilderTestHelper

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
      parse_line('PRODID', {}, '-//Meetup//RemoteApi//EN')
      assert_equal builder.component['prodid'], '-//Meetup//RemoteApi//EN'
    end

    def test_parse_version
      parse_line('VERSION', {}, '2.0')
      assert_equal @builder.component['version'], '2.0'
    end

    def test_parse_calscale
      parse_line('CALSCALE', {}, 'Gregorian')
      assert_equal builder.component['calscale'], 'Gregorian'
    end

    def test_parse_method
      parse_line('METHOD', {}, 'Publish')
      assert_equal builder.component['method'], 'Publish'
    end

    def test_parse_x_prop
      parse_line('X-ORIGINAL-URL', {}, 'http://www.google.com')
      assert_equal builder.component['x-original-url'], 'http://www.google.com'
    end

    def test_append_event_builder
      event_builder.stub :component, { 'summary' => "Bluth's Best Party" }
      builder.add('vevent', event_builder)
      assert_equal builder.component['vevent'].first['summary'], "Bluth's Best Party"
    end

    def test_append_time_zone_builder
      time_zone_builder.stub :component, { 'tzid' => 'America/Detroit' }
      builder.add('vtimezone', time_zone_builder)
      assert_equal builder.component['vtimezone'].first, { 'tzid' => 'America/Detroit' }
    end

    # Validation

    %w(prodid version).each do |property|
      define_method "test_#{property}_required" do
        assert_required property
      end
    end

    %w(prodid version calscale method).each do |property|
      define_method "test_#{property}_cant_be_defined_more_than_once" do
        assert_single property
        assert_multiple_values_do_not_overwrite property
      end
    end

    def test_single_properties
      %w(calscale method).each do |property|
        assert_single property
      end
    end

    def test_multiple_versions_uses_first
      parse_line('VERSION', {}, '2.0')
      parse_line('VERSION', {}, '3.0')
      assert_equal @builder.component['version'], '2.0'
    end

  end
end
