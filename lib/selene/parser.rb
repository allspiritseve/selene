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

    @builders = {
      'vcalendar' => CalendarBuilder,
      'vtimezone' => TimeZoneBuilder,
      'daylight' => DaylightSavingsTimeBuilder,
      'standard' => StandardTimeBuilder,
      'vevent' => EventBuilder,
      'valarm' => AlarmBuilder,
    }

    def self.builders
      @builders
    end

    def create_builder(name)
      self.class.builders[name].new
    end

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

  end
end
