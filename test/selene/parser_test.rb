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

    def test_parses_content_line
      expected = { 'VERSION' => '2.0' }
      actual = Parser.parse('VERSION:2.0')
      assert_equal expected, actual
    end

    def test_lines_are_unfolded_before_splitting
      expected = { 'WHAT' => "Say it ain't so" }
      actual = Parser.parse("WHAT:Say it\r\n  ain't so")
      assert_equal expected, actual
    end

    def test_parses_params
      ical = 'DTSTART;TZID=America/New_York:20130110T183000'
      line = Parser.new(ical).parse_line(ical, 0)
      assert_equal Line.new('DTSTART', '20130110T183000', { 'TZID' => 'America/New_York' }, line: 1), line
    end

    def test_parses_multiple_params
      ical = "BEGIN:VCALENDAR\r\nSUMMARY;ONE=UNO;TWO=DOS;THREE=TRES:Meetups\r\nEND:VCALENDAR"
      parser = Parser.new(ical)
      json = parser.parse
      assert_equal({ 'VCALENDAR' => [{ 'SUMMARY' => ['Meetups', { 'ONE' => 'UNO', 'TWO' => 'DOS', 'THREE' => 'TRES' }] }] }, json)
    end

    def test_parses_quoted_params
      ical = 'ATTENDEE;DELEGATED-TO="mailto:jdoe@example.com","mailto:jqpublic@example.com":mailto:jsmith@example.com'
      line = Parser.new(ical).parse_line(ical, 0)
      expected = { 'DELEGATED-TO' => %q("mailto:jdoe@example.com","mailto:jqpublic@example.com") }
      assert_equal expected, line.params
    end

    # def test_converts_line_back_to_ical
    #   ical = 'DTSTART;TZID=America/New_York:20130110T183000'
    #   assert_equal ical, Parser.parse(ical).to_ical

    #   ical = 'ATTENDEE;DELEGATED-TO="mailto:jdoe@example.com","mailto:jqpublic@example.com":mailto:jsmith@example.com'
    #   assert_equal ical, Parser.parse(ical).to_ical
    # end

    def test_unfolding
      summary = "Café au lait"
      folded = "SUMMARY:#{summary.bytes.insert(4, *"\n\s".bytes).pack('C*')}"
      parser = Parser.new(folded)
      assert_equal summary, parser.each_line.first.value
    end

    def test_parses_meetup_calendar
      assert_equal JSON.parse(fixture('meetup.json')), Parser.parse(fixture('meetup.ics'))
    end

    def test_parses_multiple_properties
      ical = "BEGIN:VCALENDAR\r\nBEGIN:VEVENT\r\nDESCRIPTION;TWO=DOS:First Description\r\nDESCRIPTION;ONE=UNO:Second Description\r\nEND:VEVENT\r\nEND:VCALENDAR"
      json = Parser.parse(ical)
      assert_equal({ 'VCALENDAR' => [{ 'VEVENT' => [{ 'DESCRIPTION' => [['First Description', { 'TWO' => 'DOS' }], ['Second Description', { 'ONE' => 'UNO' }]] }] }] }, json)
    end

    # def test_contain_error
    #   ical = Parser.parse("BEGIN:VEVENT\r\nEND:VEVENT")
    #   assert_collection_match ical['_errors'].map { |error| error[:message] }, /can't contain/
    # end
  end
end
