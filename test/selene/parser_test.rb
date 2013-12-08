require 'test_helper'
require 'json'

module Selene
  class ParserTest < MiniTest::Test
    include FixtureHelper

    def test_parses_blank_string
      assert_equal Selene::Parser.parse(""), {}
    end

    def test_parses_simple_calendar
      assert_equal Selene::Parser.parse("BEGIN:VCALENDAR\r\nSUMMARY:Meetups\r\nEND:VCALENDAR"),
        { 'vcalendar' => [{ 'summary' => 'Meetups' }] }
    end

    def test_parses_meetup_calendar
      assert_equal Selene::Parser.parse(fixture('meetup.ics')),
        JSON.parse(fixture('meetup.json'))
    end
  end
end
