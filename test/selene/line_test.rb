require 'test_helper'
require 'selene/line'

module Selene
  class LineTest < MiniTest::Test
    def test_lines_are_unfolded_before_splitting
      assert_equal Line.new('WHAT', "Say it ain't so", 0), Line.split("WHAT:Say it\r\n  ain't so").first
    end

    def test_parses_content_line
      assert_equal Line.new('VERSION', '2.0'), Line.parse('VERSION:2.0')
    end

    def test_parses_url
      assert_equal Line.new('TZURL', 'https://townstage.com'),
        Line.parse('TZURL:https://townstage.com')
    end

    def test_parses_params
      assert_equal Line.new('DTSTART', '20130110T183000', 1, 'tzid' => 'America/New_York'),
        Line.parse('DTSTART;TZID=America/New_York:20130110T183000', 1)
    end
  end
end
