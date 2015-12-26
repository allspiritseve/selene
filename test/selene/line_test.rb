require 'test_helper'
require 'selene/line'

module Selene
  class LineTest < MiniTest::Test
    def test_lines_are_unfolded_before_splitting
      assert_equal Line.new('WHAT', "Say it ain't so", 0), Line.each(StringIO.new("WHAT:Say it\r\n  ain't so")).first
    end

    def test_parses_content_line
      assert_equal Line.new('VERSION', '2.0'), Line.parse('VERSION:2.0')
    end

    def test_parses_url
      assert_equal Line.new('TZURL', 'https://townstage.com'),
        Line.parse('TZURL:https://townstage.com')
    end

    def test_parses_params
      assert_equal Line.new('DTSTART', '20130110T183000', 1, 'TZID' => 'America/New_York'),
        Line.parse('DTSTART;TZID=America/New_York:20130110T183000', 1)
    end

    def test_parses_quoted_params
      assert_equal Line.new('ATTENDEE', 'mailto:jsmith@example.com', nil, 'DELEGATED-TO' => ['mailto:jdoe@example.com', 'mailto:jqpublic@example.com']),
        Line.parse('ATTENDEE;DELEGATED-TO="mailto:jdoe@example.com","mailto:jqpublic@example.com":mailto:jsmith@example.com')
    end

    def test_converts_line_back_to_ical
      ical = 'DTSTART;TZID=America/New_York:20130110T183000'
      assert_equal ical, Line.parse(ical).to_ical

      ical = 'ATTENDEE;DELEGATED-TO="mailto:jdoe@example.com","mailto:jqpublic@example.com":mailto:jsmith@example.com'
      assert_equal ical, Line.parse(ical).to_ical
    end
  end
end
