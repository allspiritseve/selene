require_relative '../helper'
require 'json'
require 'selene/parser'

module Selene
  class ParserTest < MiniTest::Test
    include FixtureHelper

    def test_parses_blank_string
      assert_equal Parser.new.parse(""), {}
    end

    def test_parses_simple_calendar
      assert_equal Parser.new.parse("BEGIN:VCALENDAR\r\nSUMMARY:Meetups\r\nEND:VCALENDAR"),
        { 'vcalendar' => [{ 'summary' => 'Meetups' }] }
    end

    def test_parses_meetup_calendar
      assert_equal Parser.new.parse(fixture('meetup.ics')),
        JSON.parse(fixture('meetup.json'))
    end

    def test_contain_error
      ical = Parser.new.parse("BEGIN:VEVENT\r\nEND:VEVENT")
      assert ical['errors'].any? { |e| e.include? "can't contain" }, "Feed can't contain a vevent"
    end
  end
end
