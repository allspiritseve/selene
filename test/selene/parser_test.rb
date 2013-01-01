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

    # Sanity tests just to make sure the thing works

    def test_parses_simple_calendar
      assert_equal Selene::Parser.parse("BEGIN:VCALENDAR\r\nSUMMARY:Meetups\r\nEND:VCALENDAR"), { 'calendars' => [{ 'summary' => 'Meetups' }] }
    end

    def test_parses_meetup_calendar
      actual = Selene::Parser.parse(fixture('meetup.ics'))
      expected = JSON.parse(fixture('meetup.json'))
      assert_equal actual, expected
    end
  end
end
