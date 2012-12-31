require 'selene/calendar_builder'
require 'selene/time_zone_builder'
require 'selene/daylight_savings_time_builder'
require 'selene/standard_time_builder'
require 'selene/event_builder'

module Selene
  module Parser

    def self.parse(string)
      { 'calendars' => [] }.tap do |feed|
        stack = []
        split(string).each_with_index do |line, i|
          key, value = line.split(':', 2)
          if key.upcase == 'BEGIN'
            stack << builder(value).new
          elsif key.upcase == 'END'
            builder = stack.pop
            if !stack.empty?
              stack[-1].append(builder)
            else
              feed['calendars'] << builder.component
            end
          else
            stack[-1].parse(key, value)
          end
        end
      end
    end

    def self.builder(component)
      case component
      when 'VCALENDAR' then CalendarBuilder
      when 'VTIMEZONE' then TimeZoneBuilder
      when 'DAYLIGHT' then DaylightSavingsTimeBuilder
      when 'STANDARD' then StandardTimeBuilder
      when 'VEVENT' then EventBuilder
      else raise "Unknown component #{component}"
      end
    end

    def self.split(string)
      line_break = string.scan(/\r\n?|\n/).first || "\r\n"
      string.gsub(/#{line_break}\s/, '').split(line_break)
    end

  end
end
