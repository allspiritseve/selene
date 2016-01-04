require 'test_helper'

module Selene
  class EventBuilderTest < MiniTest::Test
    include BuilderTestHelper

    # Test properties that can contain property parameters
    %w(DTSTAMP DTSTART DTEND).each do |property|
      define_method "test_parses_#{property.downcase}_with_property_parameters" do
        builder.feed = feed_builder
        builder.parse(Line.new(property, '20130110T183000', 'tzid' => 'America/New_York'))
        assert_equal ['20130110T183000', { 'tzid' => 'America/New_York' }],
          builder.component[property]
      end
    end

    def test_parses_geo
      builder.parse(Line.new('GEO', '42.33;-83.05'))
      assert_equal builder.component['GEO'], '42.33;-83.05'
    end

    # Test properties with :required => true 
    %w(DTSTAMP UID).each do |property|
      define_method "test_#{property.downcase}_required" do
        builder.feed = feed_builder
        builder.parent = calendar_builder
        assert_required(builder, property)
      end
    end

    # Test properties with :multiple => false
    %w(DTSTAMP UID DTSTART CLASS CREATED DESCRIPTION GEO LAST-MOD LOCATION
       ORGANIZER PRIORITY SEQ STATUS SUMMARY TRANSP URL RECURID).each do |property|
      define_method "test_#{property.downcase}_cannot_be_defined_more_than_once" do
        builder.feed = feed_builder
        assert_single(builder, property)
      end
    end

    def test_invalid_parent
      assert_raises Exception do
        EventBuilder.new('VEVENT').parent = TimeZoneBuilder.new('VTIMEZONE')
      end
    end

    def test_dtstart_required_if_no_calendar_method
      builder.feed = feed_builder
      builder.parent = calendar_builder
      builder.valid?
      assert_error builder, 'DTSTART', "The 'DTSTART' property is required if the calendar does not have a 'METHOD' property"
    end

    def test_dtend_invalid_if_duration
      builder.feed = feed_builder
      builder.parse(Line.new('DURATION', 'PT15M'))
      builder.parse(Line.new('DTEND', '19970903T190000Z'))
      assert_error builder, 'DTEND', "The 'DTEND' property cannot be set if the 'DURATION' property already exists"
    end

    def test_duration_invalid_if_dtend
      builder.feed = feed_builder
      builder.parse(Line.new('DTEND', '19970903T190000Z'))
      builder.parse(Line.new('DURATION', 'PT15M'))
      assert_error builder, 'DURATION', "The 'DURATION' property cannot be set if the 'DTEND' property already exists"
    end

    def test_exdate
      builder.feed = feed_builder
      builder.parse(Line.new('EXDATE', '19960402T010000,19960403T010000,19960404T010000', { 'VALUE' => 'DATE-TIME', 'TZID' => 'America/Detroit' }))
      assert_equal builder.component['EXDATE'], ['19960402T010000,19960403T010000,19960404T010000', { 'VALUE' => 'DATE-TIME', 'TZID' => 'America/Detroit' }]
    end

    private
    def builder
      @builder ||= EventBuilder.new('VEVENT')
    end

    def feed_builder
      @feed_builder ||= FeedBuilder.new('FEED')
    end

    def calendar_builder
      @calendar_builder ||= CalendarBuilder.new('VCALENDAR')
    end
  end
end
