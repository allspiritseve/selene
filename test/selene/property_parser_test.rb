require 'test_helper'
require 'pp'

module Selene
  class PropertyParserTest < MiniTest::Test
    def test_parse_duration
      assert_equal (60 * 60), Selene::Parser.parse_duration('PT1H')
      assert_equal (60 * 60) + (30 * 60), Selene::Parser.parse_duration('PT1H30M')
      assert_equal (24 * 60 * 60) + (60 * 60) + (30 * 60) + 30, Selene::Parser.parse_duration('P1DT1H30M30S')
      assert_equal (7 * 24 * 60 * 60), Selene::Parser.parse_duration('P1W')
      assert_equal (-1 * 60 * 60), Selene::Parser.parse_duration('-PT1H')
    end
  end
end
