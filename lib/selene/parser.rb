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
        split(string).each_with_index do |content_line, i|
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
            stack[-1].parse(line[:name], line[:params], line[:value])
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

    def self.parse_content_line(string)
      string =~ /([^:\;]+)(?:\;([^:]*))?:(.*)/i
      { :name => $1, :params => parse_params($2), :value => $3 }
    end

    def self.parse_params(raw_params)
      return unless raw_params
      {}.tap do |params|
        raw_params.scan(/[^\;]+/i).map do |param|
          param =~ /([^=]+)=(.*)/
          params[$1.downcase] = $2
        end
      end
    end

  end
end
