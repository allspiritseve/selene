require_relative '../test_helper'
require 'json'
require 'selene/parser'

module Selene
  class ParserTest < MiniTest::Test
    include FixtureHelper

    def test_parses_blank_string
      assert_equal({}, Parser.parse(""))
    end

    def test_parses_simple_calendar
      assert_equal({ 'vcalendar' => [{ 'summary' => 'Meetups' }] }, Parser.parse("BEGIN:VCALENDAR\r\nSUMMARY:Meetups\r\nEND:VCALENDAR"))
    end

    def test_parses_meetup_calendar
      assert_equal JSON.parse(fixture('meetup.json')), Parser.parse(fixture('meetup.ics'))
    end

    def test_contain_error
      skip
      ical = Parser.parse("BEGIN:VEVENT\r\nEND:VEVENT")
      assert ical['errors'].any? { |e| e.include? "can't contain" }, "Feed can't contain a vevent"
    end
  end
end
