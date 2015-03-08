require 'test_helper'

module Selene
  class CalendarBuilderTest < MiniTest::Test
    include BuilderTestHelper

    def test_append_event_builder
      builder = CalendarBuilder.new
      event_builder = EventBuilder.new.extend(Stubbable)
      event_builder.stub :component, { 'summary' => "Bluth's Best Party" }
      builder.add('vevent', event_builder)
      assert_equal builder.component['vevent'].first['summary'], "Bluth's Best Party"
    end

    def test_append_time_zone_builder
      builder = CalendarBuilder.new
      time_zone_builder = TimeZoneBuilder.new.extend(Stubbable)
      time_zone_builder.stub :component, { 'tzid' => 'America/Detroit' }
      builder.add('vtimezone', time_zone_builder)
      assert_equal builder.component['vtimezone'].first, { 'tzid' => 'America/Detroit' }
    end

    # Test properties with :required => true
    %w(prodid version).each do |property|
      define_method "test_#{property}_required" do
        assert_required(CalendarBuilder.new, property)
      end
    end

    # Test properties with :multiple => false
    %w(prodid version calscale method).each do |property|
      define_method "test_#{property}_cannot_be_defined_more_than_once" do
        assert_single(CalendarBuilder.new, property)
      end
    end

  end
end
