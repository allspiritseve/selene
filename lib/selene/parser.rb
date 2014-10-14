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
    BUILDER_CLASSES = {
      'vcalendar' => CalendarBuilder,
      'vtimezone' => TimeZoneBuilder,
      'daylight' => DaylightSavingsTimeBuilder,
      'standard' => StandardTimeBuilder,
      'vevent' => EventBuilder,
      'valarm' => AlarmBuilder,
    }

    def self.parse(string)
      new(string).parse
    end

    def initialize(string)
      @string = string
    end

    def parse
      feed = FeedBuilder.new
      Line.split(@string).inject([feed]) do |stack, line|
        if line.begin_component?
          builder = create_builder(line.component_name)
          stack[-1].add(line.component_name, builder)
          stack + [builder]
        elsif line.end_component?
          stack - [stack[-1]]
        else
          stack[-1].parse(line)
          stack
        end
      end
      feed.component
    end

    private
    def create_builder(component_name)
      builder_class(component_name).new(component_name)
    end

    def builder_class(component_name)
      BUILDER_CLASSES.fetch(component_name, ComponentBuilder)
    end
  end
end
