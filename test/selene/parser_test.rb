require 'test_helper'
require 'json'

module Selene
  class ParserTest < TestCase

    # Line breaks
    def test_lines_are_unfolded_before_splitting
      assert_equal Selene::Parser.split("This is a\r\n  test"), ["This is a test"]
    end

    def test_parse_blank_string
      assert_equal Selene::Parser.parse(""), { 'calendars' => [] }
    end

    def test_parse_blank_calendar
      assert_equal Selene::Parser.parse("BEGIN:VCALENDAR\r\nEND:VCALENDAR"), { 'calendars' => [{}] }
    end

    def test_parse_meetup_calendar
      actual = Selene::Parser.parse(fixture('meetup.ics'))
      expected = JSON.parse(fixture('meetup.json'))
      assert_equal actual, expected
    end
  end
end
