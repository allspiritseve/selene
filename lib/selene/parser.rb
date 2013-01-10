require 'selene/line'
require 'selene/component_rules'
require 'selene/component_builder'

require 'selene/alarm_builder'
require 'selene/calendar_builder'
require 'selene/daylight_savings_time_builder'
require 'selene/event_builder'
require 'selene/standard_time_builder'
require 'selene/time_zone_builder'

module Selene
  module Parser

    def self.builder(component)
      case component.downcase
      when 'vcalendar' then CalendarBuilder
      when 'vtimezone' then TimeZoneBuilder
      when 'daylight' then DaylightSavingsTimeBuilder
      when 'standard' then StandardTimeBuilder
      when 'vevent' then EventBuilder
      when 'valarm' then AlarmBuilder
      else ComponentBuilder
      end
    end

    def self.parse(string)
      stack = []
      stack << builder('feed').new
      Line.split(string).each do |line|
        if line.begin_component?
          builder = builder(line.value).new
          stack[-1].add(line.value, builder) unless stack.empty?
          stack << builder
        elsif line.end_component?
          stack.pop
        else
          stack[-1].parse(line)
        end
      end
      stack[-1].component
    end

  end
end
