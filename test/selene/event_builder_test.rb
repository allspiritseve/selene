require 'test_helper'

module Selene
  class EventBuilderTest < TestCase

    def builder
      @builder ||= EventBuilder.new
    end

    def test_parses_dtstart
      expected = ['20130110T183000', { 'tzid' => 'America/New_York' }]
      parse_line('DTSTART', { 'tzid' => 'America/New_York' }, '20130110T183000')
      assert_equal builder.component['dtstart'], expected
    end

    def test_parses_dtstamp
      parse_line('DTSTAMP', nil, '20121231T093631Z')
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
      parse_line('DTEND', nil, '20130110T183000')
      assert_equal builder.component['dtend'], '20130110T183000'
    end

    def test_parses_status
      parse_line('STATUS', nil, 'CONFIRMED')
      assert_equal builder.component['status'], 'CONFIRMED'
    end

    def test_parses_summary
      parse_line('SUMMARY', nil, 'DetroitRuby: 2012 Plan + Lightning talks')
      assert_equal builder.component['summary'], 'DetroitRuby: 2012 Plan + Lightning talks'
    end

    def test_parses_description
      parse_line('DESCRIPTION', nil, 'DetroitRuby\nThursday\, January 10 at 6:30 PM\n\n')
      assert_equal builder.component['description'], 'DetroitRuby\nThursday\, January 10 at 6:30 PM\n\n'
    end

    def test_parses_class
      parse_line('CLASS', nil, 'PUBLIC')
      assert_equal builder.component['class'], 'PUBLIC'
    end

    def test_parses_created
      parse_line('CREATED', nil, '20120106T161509Z')
      assert_equal builder.component['created'], '20120106T161509Z'
    end

    def test_parses_geo
      parse_line('GEO', nil, '42.33;-83.05')
      assert_equal builder.component['geo'], ['42.33', '-83.05']
    end

    def test_parses_location
      parse_line('LOCATION', nil, 'Compuware Building (One Campus Martius\, Detroit\, MI 48226)')
      assert_equal builder.component['location'], 'Compuware Building (One Campus Martius\, Detroit\, MI 48226)'
    end

    def test_parses_url
      parse_line('URL', nil, 'http://www.meetup.com/DetroitRuby/events/93346412/')
      assert_equal builder.component['url'], 'http://www.meetup.com/DetroitRuby/events/93346412/'
    end

    def test_parses_last_modified
      parse_line('LAST-MODIFIED', nil, '20120106T161509Z')
      assert_equal builder.component['last-modified'], '20120106T161509Z'
    end

    def test_parses_uid
      parse_line('UID', nil, 'event_qgkxkcyrcbnb@meetup.com')
      assert_equal builder.component['uid'], 'event_qgkxkcyrcbnb@meetup.com'
    end

  end
end
