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
    def parse(string)
      errors = Hash.new { |h, k| h[k] = [] }
      builder = FeedBuilder.new
      Line.split(string).each do |line|
        case line
        when BeginComponentLine
          stack << create_builder(line, errors)
          stack[-1].parse(line)
        when EndComponentLine
          stack.pop
        else
          stack[-1].parse(line)
        end
      end
      feed.component
    end

    private

    def create_builder(line, errors)
      builder_class(line.name).new(line.value, errors)
    end

    def create_component(line)
      Component.new
    end

    def builder_class(name)
      case name
      when 'vcalendar' then CalendarBuilder
      when 'vtimezone' then TimeZoneBuilder
      when 'daylight' then DaylightSavingsTimeBuilder
      when 'standard' then StandardTimeBuilder
      when 'vevent' then EventBuilder
      when 'valarm' then AlarmBuilder
      else ComponentBuilder
      end
    end
  end
end
