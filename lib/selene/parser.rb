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
        split(string).each_with_index do |raw_line, i|
          name, params, value = separate_line(raw_line).values_at :name, :params, :value
          if name.upcase == 'BEGIN'
            stack << builder(value).new
          elsif name.upcase == 'END'
            builder = stack.pop
            if !stack.empty?
              stack[-1].append(builder)
            else
              feed['calendars'] << builder.component
            end
          else
            stack[-1].parse(name, params, value)
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

    def self.separate_line(raw_line)
      raw_line.split(':', 2).tap do |name, value|
        return { :name => name, :value => value }
      end
    end

  end
end
