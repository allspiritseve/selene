require 'test_helper'

module Selene
  class EventBuilderTest < TestCase

    def builder
      @builder ||= EventBuilder.new
    end

    def test_parses_dtstart
      expected = ['20130110T183000', { 'tzid' => 'America/New_York' }]
      assert_equal builder.parse('DTSTART', { 'tzid' => 'America/New_York' }, '20130110T183000'), expected
    end

    def test_parses_dtstart_without_tzid
      assert_equal builder.parse('DTSTART', nil, '20130110T183000'), '20130110T183000'
    end

    def test_parses_dtend
      expected = ['20130110T183000', { 'tzid' => 'America/New_York' }]
      assert_equal builder.parse('DTEND', { 'tzid' => 'America/New_York' }, '20130110T183000'), expected
    end

    def test_parses_dtstart_without_tzid
      assert_equal builder.parse('DTEND', nil, '20130110T183000'), '20130110T183000'
    end

  end
end
