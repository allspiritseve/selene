require 'test_helper'

module Selene
  class EventBuilderTest < MiniTest::Test
    include BuilderTestHelper

    # Sanity check
    def test_parses_standard_property
      builder = EventBuilder.new
      builder.parse(Line.new('STATUS', {}, 'Confirmed'))
      assert_equal builder.component['status'], 'Confirmed'
    end

    # Test properties that can contain property parameters
    %w(dtstamp dtstart dtend).each do |property|
      define_method "test_parses_#{property}_with_property_parameters" do
        builder = EventBuilder.new
        builder.parse(Line.new(property.upcase, { 'tzid' => 'America/New_York' }, '20130110T183000'))
        assert_equal ['20130110T183000', { 'tzid' => 'America/New_York' }],
          builder.component[property.downcase]
      end
    end

    def test_parses_geo_with_multiple_values
      builder = EventBuilder.new
      builder.parse(Line.new('GEO', {}, '42.33;-83.05'))
      assert_equal builder.component['geo'], ['42.33', '-83.05']
    end

    # Test properties with :required => true 
    %w(dtstamp uid).each do |property|
      define_method "test_#{property}_required" do
        builder = EventBuilder.new
        builder.parent = CalendarBuilder.new
        assert_required(builder, property)
      end
    end

    # Test properties with :multiple => false
    %w(dtstamp uid dtstart class created description geo last-mod location
       organizer priority seq status summary transp url recurid).each do |property|
      define_method "test_#{property}_cannot_be_defined_more_than_once" do
        assert_single(EventBuilder.new, property)
      end
    end

    def test_invalid_parent
      assert_raises Exception do
        EventBuilder.new.parent = TimeZoneBuilder.new
      end
    end

    def test_dtstart_required_if_no_calendar_method
      builder = EventBuilder.new
      builder.parent = CalendarBuilder.new
      builder.valid?
      assert_error builder, 'dtstart', "The 'dtstart' property is required if the calendar does not have a 'method' property"
    end

    def test_dtend_invalid_if_duration
      builder = EventBuilder.new
      builder.parse(Line.new('DURATION', {}, 'PT15M'))
      builder.parse(Line.new('DTEND', {}, '19970903T190000Z'))
      assert_error builder, 'dtend', "The 'dtend' property cannot be set if the 'duration' property already exists"
    end

    def test_duration_invalid_if_dtend
      builder = EventBuilder.new
      builder.parse(Line.new('DTEND', {}, '19970903T190000Z'))
      builder.parse(Line.new('DURATION', {}, 'PT15M'))
      assert_error builder, 'duration', "The 'duration' property cannot be set if the 'dtend' property already exists"
    end

  end
end
