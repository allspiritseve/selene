require 'test_helper'

class Selene::ParserTest < MiniTest::Unit::TestCase

  def test_unfolding
    assert_equal Selene::Parser.unfold("This is a\r\n  test"), "This is a test"
  end

  def test_parse_blank_string
    assert_equal Selene::Parser.parse(""), { :calendars => [] }
  end

  def test_parse_blank_calendar
    assert_equal Selene::Parser.parse("BEGIN:VCALENDAR\r\nEND:VCALENDAR"), { :calendars => [{}] }
  end

end
