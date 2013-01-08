require 'test_helper'

module Selene
  class LineTest < TestCase

    def test_lines_are_unfolded_before_splitting
      assert_equal Line.split("TEST:This is a\r\n  test").first.value, "This is a test"
    end

    def test_parses_content_line
      assert_equal Line.parse('VERSION:2.0'), Line.new('VERSION', {}, '2.0')
    end

    def test_parses_url
      assert_equal Line.parse('TZURL:http://www.meetup.com/DetroitRuby/events/ical/DetroitRuby/'),
        Line.new('TZURL', {}, 'http://www.meetup.com/DetroitRuby/events/ical/DetroitRuby/')
    end

    def test_parses_params
      assert_equal Line.parse('DTSTART;TZID=America/New_York:20130110T183000'),
        Line.new('DTSTART', { 'tzid' => 'America/New_York' }, '20130110T183000')
    end
  end
end
