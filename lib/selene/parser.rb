require 'selene/alarm_builder'
require 'selene/calendar_builder'
require 'selene/daylight_savings_time_builder'
require 'selene/event_builder'
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
        split_content_lines(string).each_with_index do |content_line, i|
          line = parse_content_line(content_line)
          if line[:name].upcase == 'BEGIN'
            stack << builder(line[:value]).new
          elsif line[:name].upcase == 'END'
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

    def self.parse_content_line(string)
      string =~ /([^:\;]+)(?:\;([^:]*))?:(.*)/i
      content_line($1, parse_params($2), $3)
    end

    def self.content_line(name, params, value)
      { :name => name, :params => params, :value => value }
    end

    def self.parse_date_and_time(line)
      line[:params] && line[:params] != {} ? [line[:value], line[:params]] : line[:value]
    end

    def self.parse_params(raw_params)
      {}.tap do |params|
        return params unless raw_params
        raw_params.scan(/[^\;]+/i).map do |param|
          param =~ /([^=]+)=(.*)/
          params[$1.downcase] = $2
        end
      end
    end

    def self.split_content_lines(string)
      line_break = string.scan(/\r\n?|\n/).first || "\r\n"
      string.gsub(/#{line_break}\s/, '').split(line_break)
    end

  end
end
