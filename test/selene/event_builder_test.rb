require 'test_helper'

module Selene
  class EventBuilderTest < TestCase

    def builder
      @builder ||= EventBuilder.new
    end

    def test_parses_dtstart
      expected = ['20130110T183000', { 'tzid' => 'America/New_York' }]
      builder.parse('DTSTART', { 'tzid' => 'America/New_York' }, '20130110T183000')
      assert_equal builder.component['dtstart'], expected
    end

    def test_parses_dtstamp
      builder.parse('DTSTAMP', nil, '20121231T093631Z')
      assert_equal builder.component['dtstamp'], '20121231T093631Z'
    end

    def test_parses_dtstart_without_tzid
      builder.parse('DTSTART', nil, '20130110T183000')
      assert_equal builder.component['dtstart'], '20130110T183000'
    end

    def test_parses_dtend
      expected = ['20130110T183000', { 'tzid' => 'America/New_York' }]
      builder.parse('DTEND', { 'tzid' => 'America/New_York' }, '20130110T183000')
      assert_equal builder.component['dtend'], expected
    end

    def test_parses_dtstart_without_tzid
      builder.parse('DTEND', nil, '20130110T183000')
      assert_equal builder.component['dtend'], '20130110T183000'
    end

    def test_parses_status
      builder.parse('STATUS', nil, 'CONFIRMED')
      assert_equal builder.component['status'], 'CONFIRMED'
    end

    def test_parses_summary
      builder.parse('SUMMARY', nil, 'DetroitRuby: 2012 Plan + Lightning talks')
      assert_equal builder.component['summary'], 'DetroitRuby: 2012 Plan + Lightning talks'
    end

    def test_parses_description
      builder.parse('DESCRIPTION', nil, 'DetroitRuby\nThursday\, January 10 at 6:30 PM\n\n')
      assert_equal builder.component['description'], 'DetroitRuby\nThursday\, January 10 at 6:30 PM\n\n'
    end

    def test_parses_class
      builder.parse('CLASS', nil, 'PUBLIC')
      assert_equal builder.component['class'], 'PUBLIC'
    end

    def test_parses_created
      builder.parse('CREATED', nil, '20120106T161509Z')
      assert_equal builder.component['created'], '20120106T161509Z'
    end

    def test_parses_geo
      builder.parse('GEO', nil, '42.33;-83.05')
      assert_equal builder.component['geo'], ['42.33', '-83.05']
    end

    def test_parses_location
      builder.parse('LOCATION', nil, 'Compuware Building (One Campus Martius\, Detroit\, MI 48226)')
      assert_equal builder.component['location'], 'Compuware Building (One Campus Martius\, Detroit\, MI 48226)'
    end

    def test_parses_url
      builder.parse('URL', nil, 'http://www.meetup.com/DetroitRuby/events/93346412/')
      assert_equal builder.component['url'], 'http://www.meetup.com/DetroitRuby/events/93346412/'
    end

    def test_parses_last_modified
      builder.parse('LAST-MODIFIED', nil, '20120106T161509Z')
      assert_equal builder.component['last-modified'], '20120106T161509Z'
    end

    def test_parses_uid
      builder.parse('UID', nil, 'event_qgkxkcyrcbnb@meetup.com')
      assert_equal builder.component['uid'], 'event_qgkxkcyrcbnb@meetup.com'
    end

  end
end
