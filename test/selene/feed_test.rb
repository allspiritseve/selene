require_relative '../helper'
require 'json'
require 'selene/parser'
require 'selene/feed'

module Selene
  class FeedTest < MiniTest::Test
    def test_build_calendar
      feed = Feed.new
      feed << Line.new('BEGIN', 'VCALENDAR')
      assert_equal({ 'vcalendar' => [] }, feed.feed)
    end
  end
end


feed = Feed.new
feed << Line.new
feed << Line.new
feed << Line.new

feed = Feed.new
lines.inject(feed) do |feed, line|
  CalendarBuilder.new(feed).parse(line)
end

def parse(line)
  if feed.current
  if @context.empty?

  else
  end
end
