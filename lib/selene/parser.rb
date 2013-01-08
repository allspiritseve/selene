require 'selene/alarm_builder'
require 'selene/calendar_builder'
require 'selene/daylight_savings_time_builder'
require 'selene/event_builder'
require 'selene/line'
require 'selene/standard_time_builder'
require 'selene/time_zone_builder'

module Selene
  module Parser

    def self.builder(component)
      case component
      when 'VCALENDAR' then CalendarBuilder
      when 'VTIMEZONE' then TimeZoneBuilder
      when 'DAYLIGHT' then DaylightSavingsTimeBuilder
      when 'STANDARD' then StandardTimeBuilder
      when 'VEVENT' then EventBuilder
      when 'VALARM' then AlarmBuilder
      else raise "Unknown component #{component}"
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
