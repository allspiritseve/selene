require 'test_helper'

module Selene
  class EventBuilderTest < MiniTest::Test
    include BuilderTestHelper

    # Sanity check
    def test_parses_standard_property
      builder = EventBuilder.new('vevent')
      builder.parse(Line.new('STATUS', {}, 'Confirmed'))
      assert_equal builder.component['status'], 'Confirmed'
    end

    # Test properties that can contain property parameters
    %w(dtstamp dtstart dtend).each do |property|
      define_method "test_parses_#{property}_with_property_parameters" do
        builder = EventBuilder.new('vevent')
        builder.parse(Line.new(property.upcase, { 'tzid' => 'America/New_York' }, '20130110T183000'))
        assert_equal ['20130110T183000', { 'tzid' => 'America/New_York' }],
          builder.component[property.downcase]
      end
    end

    def test_parses_geo_with_multiple_values
      builder = EventBuilder.new('vevent')
      builder.parse(Line.new('GEO', {}, '42.33;-83.05'))
      assert_equal builder.component['geo'], ['42.33', '-83.05']
    end

    # Test properties with :required => true 
    %w(dtstamp uid).each do |property|
      define_method "test_#{property}_required" do
        builder = EventBuilder.new('vevent')
        builder.parent = CalendarBuilder.new('vcalendar')
        assert_required(builder, property)
      end
    end

    # Test properties with :multiple => false
    %w(dtstamp uid dtstart class created description geo last-mod location
       organizer priority seq status summary transp url recurid).each do |property|
      define_method "test_#{property}_cannot_be_defined_more_than_once" do
        assert_single(EventBuilder.new('vevent'), property)
      end
    end

    def test_invalid_parent
      builder = EventBuilder.new('vevent')
      assert_raises Exception do
        builder.parent = TimeZoneBuilder.new('vtimezone')
      end
    end

    def test_dtstart_required_if_no_calendar_method
      builder = EventBuilder.new('vevent')
      builder.parent = CalendarBuilder.new('vcalendar')
      builder.valid?
      assert_error builder, 'dtstart', "The 'dtstart' property is required if the calendar does not have a 'method' property"
    end

  end
end
