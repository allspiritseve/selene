require 'test_helper'
require 'json'

module Selene
  class ParserTest < TestCase

    def test_lines_are_unfolded_before_splitting
      assert_equal Selene::Parser.split("This is a\r\n  test").first, "This is a test"
    end

    def test_parses_blank_string
      assert_equal Selene::Parser.parse(""), { 'calendars' => [] }
    end

    def test_parses_content_line
      assert_equal Selene::Parser.parse_content_line('VERSION:2.0'), { :name => 'VERSION', :params => nil, :value => '2.0' }
    end

    def test_parses_content_line_with_url
      expected = { :name => 'TZURL', :params => nil, :value => 'http://www.meetup.com/DetroitRuby/events/ical/DetroitRuby/' }
      assert_equal Selene::Parser.parse_content_line('TZURL:http://www.meetup.com/DetroitRuby/events/ical/DetroitRuby/'), expected
    end

    def test_parses_content_line_with_param
      expected = { :name => 'DTSTART', :params => { 'tzid' => 'America/New_York' }, :value => '20130110T183000' } 
      assert_equal Selene::Parser.parse_content_line('DTSTART;TZID=America/New_York:20130110T183000'), expected
    end

    # Sanity tests just to make sure the thing works

    def test_parses_simple_calendar
      assert_equal Selene::Parser.parse("BEGIN:VCALENDAR\r\nSUMMARY:Meetups\r\nEND:VCALENDAR"), { 'calendars' => [{ 'summary' => 'Meetups' }] }
    end

    def test_parses_meetup_calendar
      expected = JSON.parse(fixture('meetup.json'))
      assert_equal Selene::Parser.parse(fixture('meetup.ics')), expected
    end
  end
end
