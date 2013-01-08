require 'test_helper'
require 'json'

module Selene
  class ParserTest < MiniTest::Unit::TestCase
    include FixtureHelper

    def test_parses_blank_string
      assert_equal Selene::Parser.parse(""), { 'calendars' => [] }
    end

    def test_parses_simple_calendar
      assert_equal Selene::Parser.parse("BEGIN:VCALENDAR\r\nSUMMARY:Meetups\r\nEND:VCALENDAR"),
        { 'calendars' => [{ 'summary' => 'Meetups' }] }
    end

    def test_parses_meetup_calendar
      assert_equal Selene::Parser.parse(fixture('meetup.ics')),
        JSON.parse(fixture('meetup.json'))
    end
  end
end
