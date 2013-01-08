require 'test_helper'

module Selene
  class EventBuilderTest < MiniTest::Unit::TestCase
    include BuilderTestHelper

    def builder
      @builder ||= EventBuilder.new
    end

    def test_parses_dtstart
      parse_line('DTSTART', { 'tzid' => 'America/New_York' }, '20130110T183000')
      assert_equal builder.component['dtstart'],
        ['20130110T183000', { 'tzid' => 'America/New_York' }]
    end

    def test_parses_dtstamp
      parse_line('DTSTAMP', {}, '20121231T093631Z')
      assert_equal builder.component['dtstamp'], '20121231T093631Z'
    end

    def test_parses_dtstart_without_tzid
      parse_line('DTSTART', {}, '20130110T183000')
      assert_equal builder.component['dtstart'], '20130110T183000'
    end

    def test_parses_dtend
      parse_line('DTEND', { 'tzid' => 'America/New_York' }, '20130110T183000')
      assert_equal builder.component['dtend'], ['20130110T183000', { 'tzid' => 'America/New_York' }]
    end

    def test_parses_dtstart_without_tzid
      parse_line('DTEND', {}, '20130110T183000')
      assert_equal builder.component['dtend'], '20130110T183000'
    end

    def test_parses_status
      parse_line('STATUS', {}, 'CONFIRMED')
      assert_equal builder.component['status'], 'CONFIRMED'
    end

    def test_parses_summary
      parse_line('SUMMARY', {}, 'DetroitRuby: 2012 Plan + Lightning talks')
      assert_equal builder.component['summary'], 'DetroitRuby: 2012 Plan + Lightning talks'
    end

    def test_parses_description
      parse_line('DESCRIPTION', {}, 'DetroitRuby\nThursday\, January 10 at 6:30 PM\n\n')
      assert_equal builder.component['description'], 'DetroitRuby\nThursday\, January 10 at 6:30 PM\n\n'
    end

    def test_parses_class
      parse_line('CLASS', {}, 'PUBLIC')
      assert_equal builder.component['class'], 'PUBLIC'
    end

    def test_parses_created
      parse_line('CREATED', {}, '20120106T161509Z')
      assert_equal builder.component['created'], '20120106T161509Z'
    end

    def test_parses_geo
      parse_line('GEO', {}, '42.33;-83.05')
      assert_equal builder.component['geo'], ['42.33', '-83.05']
    end

    def test_parses_location
      parse_line('LOCATION', {}, 'Compuware Building (One Campus Martius\, Detroit\, MI 48226)')
      assert_equal builder.component['location'], 'Compuware Building (One Campus Martius\, Detroit\, MI 48226)'
    end

    def test_parses_url
      parse_line('URL', {}, 'http://www.meetup.com/DetroitRuby/events/93346412/')
      assert_equal builder.component['url'], 'http://www.meetup.com/DetroitRuby/events/93346412/'
    end

    def test_parses_last_modified
      parse_line('LAST-MODIFIED', {}, '20120106T161509Z')
      assert_equal builder.component['last-modified'], '20120106T161509Z'
    end

    def test_parses_uid
      parse_line('UID', {}, 'event_qgkxkcyrcbnb@meetup.com')
      assert_equal builder.component['uid'], 'event_qgkxkcyrcbnb@meetup.com'
    end

    # Validation

    %w(dtstamp uid).each do |property|
      define_method "test_#{property}_required" do
        assert_required property
      end
    end

    %w(dtstamp uid dtstart class created description geo last-mod location organizer priority seq status summary transp url recurid).each do |property|
      define_method "test_#{property}_cant_be_defined_more_than_once" do
        assert_single property
        assert_multiple_values_do_not_overwrite property
      end
    end

    def test_adding_to_non_calendar_raises_exception
      assert_raises Exception do
        builder.parent = TimeZoneBuilder.new
      end
    end
  end
end
