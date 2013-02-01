require 'selene/line'
require 'selene/component_rules'
require 'selene/component_builder'

require 'selene/alarm_builder'
require 'selene/calendar_builder'
require 'selene/feed_builder'
require 'selene/daylight_savings_time_builder'
require 'selene/event_builder'
require 'selene/standard_time_builder'
require 'selene/time_zone_builder'

module Selene
  module Parser

    BUILDERS = { 
      'feed' => FeedBuilder,
      'vcalendar' => CalendarBuilder,
      'vtimezone' => TimeZoneBuilder,
      'daylight' => DaylightSavingsTimeBuilder,
      'standard' => StandardTimeBuilder,
      'vevent' => EventBuilder,
      'valarm' => AlarmBuilder,
    }

    def self.create_builder(name)
      (BUILDERS[name] || ComponentBuilder).new(name)
    end

    def self.parse(string)
      stack = []
      feed = create_builder('feed')
      stack << feed
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
