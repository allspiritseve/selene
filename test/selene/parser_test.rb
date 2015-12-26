require 'test_helper'
require 'json'
require 'selene/parser'

module Selene
  class ParserTest < MiniTest::Test
    include FixtureHelper

    def test_parses_blank_string
      assert_equal({}, Parser.parse(""))
    end

    def test_parses_simple_calendar
      assert_equal({ 'VCALENDAR' => [{ 'SUMMARY' => 'Meetups' }] }, Parser.parse("BEGIN:VCALENDAR\r\nSUMMARY:Meetups\r\nEND:VCALENDAR"))
    end

    def test_unfolding
      summary = "Café au lait"
      folded = "SUMMARY:#{summary.bytes.insert(4, *"\n\s".bytes).pack('C*')}"
      parser = Parser.new(folded)
      assert_equal summary, parser.each_line.first[:value]
    end

    def test_parses_meetup_calendar
      assert_equal JSON.parse(fixture('meetup.json')), Parser.parse(fixture('meetup.ics'))
    end

    # def test_contain_error
    #   ical = Parser.parse("BEGIN:VEVENT\r\nEND:VEVENT")
    #   assert_collection_match ical['_errors'].map { |error| error[:message] }, /can't contain/
    # end
  end
end
