require 'test_helper'

module Selene
  class EventBuilderTest < MiniTest::Test
    include BuilderTestHelper

    # Test properties that can contain property parameters
    %w(dtstamp dtstart dtend).each do |property|
      define_method "test_parses_#{property}_with_property_parameters" do
        builder = EventBuilder.new('vevent')
        builder.parse(Line.new(property.upcase, '20130110T183000', 'tzid' => 'America/New_York'))
        assert_equal ['20130110T183000', { 'tzid' => 'America/New_York' }],
          builder.component[property]
      end
    end

    def test_parses_geo_with_multiple_values
      builder = EventBuilder.new('vevent')
      builder.parse(Line.new('GEO', '42.33;-83.05'))
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
      assert_raises Exception do
        EventBuilder.new('vevent').parent = TimeZoneBuilder.new('vtimezone')
      end
    end

    def test_dtstart_required_if_no_calendar_method
      builder = EventBuilder.new('vevent')
      builder.parent = CalendarBuilder.new('vevent')
      builder.valid?
      assert_error builder, 'dtstart', "The 'dtstart' property is required if the calendar does not have a 'method' property"
    end

    def test_dtend_invalid_if_duration
      builder = EventBuilder.new('vevent')
      builder.parse(Line.new('DURATION', {}, 'PT15M'))
      builder.parse(Line.new('DTEND', {}, '19970903T190000Z'))
      assert_error builder, 'dtend', "The 'dtend' property cannot be set if the 'duration' property already exists"
    end

    def test_duration_invalid_if_dtend
      builder = EventBuilder.new('vevent')
      builder.parse(Line.new('DTEND', {}, '19970903T190000Z'))
      builder.parse(Line.new('DURATION', {}, 'PT15M'))
      assert_error builder, 'duration', "The 'duration' property cannot be set if the 'dtend' property already exists"
    end

    def test_exdate
      builder = EventBuilder.new('vevent')
      builder.parse("EXDATE;VALUE=DATE-TIME;TZID=America/Detroit:19960402T010000,19960403T010000,19960404T010000")
      assert_equal builder.component['exdate'], [['19960402T010000','19960403T010000','19960404T010000'], { 'value' => 'DATE-TIME', 'tzid' => 'America/Detroit' }]
    end
  end
end
