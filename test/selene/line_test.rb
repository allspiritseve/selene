require 'test_helper'

module Selene
  class LineTest < TestCase

    def test_lines_are_unfolded_before_splitting
      assert_equal Line.split("TEST:This is a\r\n  test").first.value, "This is a test"
    end

    def test_parses_content_line
      assert_equal Line.parse('VERSION:2.0'), { :name => 'VERSION', :params => {}, :value => '2.0' }
    end

    def test_parses_url
      expected = { :name => 'TZURL', :params => {}, :value => 'http://www.meetup.com/DetroitRuby/events/ical/DetroitRuby/' }
      assert_equal Line.parse('TZURL:http://www.meetup.com/DetroitRuby/events/ical/DetroitRuby/'), expected
    end

    def test_parses_params
      expected = { :name => 'DTSTART', :params => { 'tzid' => 'America/New_York' }, :value => '20130110T183000' }
      assert_equal Line.parse('DTSTART;TZID=America/New_York:20130110T183000'), expected
    end
  end
end
