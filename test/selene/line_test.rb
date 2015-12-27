require 'test_helper'
require 'selene/line'

module Selene
  class LineTest < MiniTest::Test
    def test_lines_are_unfolded_before_splitting
      expected = { :WHAT => "Say it ain't so" }
      actual = Parser.parse("WHAT:Say it\r\n  ain't so")
      assert_equal expected, actual
    end

    def test_parses_content_line
      expected = { :VERSION => '2.0' }
      actual = Parser.parse('VERSION:2.0')
      assert_equal expected, actual
    end

    # def test_parses_url
    #   assert_equal Line.new('TZURL', 'https://townstage.com'),
    #     Selene::Parser.parse_line('TZURL:https://townstage.com')
    # end

    # def test_parses_params
    #   assert_equal Line.new('DTSTART', '20130110T183000', 1, 'TZID' => 'America/New_York'),
    #     Selene::Parser.parse_line('DTSTART;TZID=America/New_York:20130110T183000', 1)
    # end

    # def test_parses_quoted_params
    #   assert_equal Line.new('ATTENDEE', 'mailto:jsmith@example.com', nil, 'DELEGATED-TO' => ['mailto:jdoe@example.com', 'mailto:jqpublic@example.com']),
    #     Selene::Parser.parse_line('ATTENDEE;DELEGATED-TO="mailto:jdoe@example.com","mailto:jqpublic@example.com":mailto:jsmith@example.com')
    # end

    # def test_converts_line_back_to_ical
    #   ical = 'DTSTART;TZID=America/New_York:20130110T183000'
    #   assert_equal ical, Selene::Parser.parse_line(ical).to_ical

    #   ical = 'ATTENDEE;DELEGATED-TO="mailto:jdoe@example.com","mailto:jqpublic@example.com":mailto:jsmith@example.com'
    #   assert_equal ical, Selene::Parser.parse_line(ical).to_ical
    # end
  end
end
