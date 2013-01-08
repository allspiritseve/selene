require 'selene/alarm_builder'
require 'selene/builder_helper'
require 'selene/calendar_builder'
require 'selene/component_builder'
require 'selene/daylight_savings_time_builder'
require 'selene/event_builder'
require 'selene/line'
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
      { 'calendars' => [] }.tap do |feed|
        stack = []
        Line.split(string).each do |line|
          if line.begin_component?
            stack << builder(line.value).new
          elsif line.end_component?
            builder = stack.pop
            if !stack.empty?
              stack[-1].append(builder)
            else
              feed['calendars'] << builder.component
            end
          else
            stack[-1].parse(line)
          end
        end
      end
    end

  end
end
