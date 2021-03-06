require 'selene/line'

require 'selene/component_builder'
require 'selene/alarm_builder'
require 'selene/calendar_builder'
require 'selene/daylight_savings_time_builder'
require 'selene/event_builder'
require 'selene/feed_builder'
require 'selene/standard_time_builder'
require 'selene/time_zone_builder'

module Selene
  class Parser
    def self.parse(data)
      new(data).parse
    end

    def initialize(data)
      @data = encode(data)
    end

    def encode(data)
      data.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    end

    def parse
      feed = FeedBuilder.new
      stack = [feed]
      Line.split(@data) do |line|
        if line.begin_component?
          builder = create_builder(line.component_name)
          stack[-1].add(line.component_name, builder)
          stack << builder
        elsif line.end_component?
          stack.pop
        else
          stack[-1].parse(line)
        end
      end
      feed.component
    end

    def create_builder(name)
      case name
      when 'daylight' then DaylightSavingsTimeBuilder.new
      when 'standard' then StandardTimeBuilder.new
      when 'valarm' then AlarmBuilder.new
      when 'vcalendar' then CalendarBuilder.new
      when 'vevent' then EventBuilder.new
      when 'vtimezone' then TimeZoneBuilder.new
      else ComponentBuilder.new(name)
      end
    end
  end
end
