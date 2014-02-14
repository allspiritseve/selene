require 'selene/line'

require 'selene/component_builder'
require 'selene/alarm_builder'
require 'selene/calendar_builder'
require 'selene/feed_builder'
require 'selene/daylight_savings_time_builder'
require 'selene/event_builder'
require 'selene/standard_time_builder'
require 'selene/time_zone_builder'

module Selene
  class Parser
    def parse(string)
      feed = FeedBuilder.new
      stack = [feed]
      Line.split(string).each do |line|
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

    private

    def create_builder(name)
      builder_class(name).new(name)
    end

    def builder_class(name)
      case name
      when 'vcalendar' then CalendarBuilder
      when 'vtimezone' then TimeZoneBuilder
      when 'daylight' then DaylightSavingsTimeBuilder
      when 'standard' then StandardTimeBuilder
      when 'vevent' then EventBuilder
      when 'valarm' then AlarmBuilder
      else ComponentBuilder
      end
    end
  end
end
