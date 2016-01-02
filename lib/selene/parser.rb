require 'selene/line'

require 'selene/component_builder'
require 'selene/alarm_builder'
require 'selene/calendar_builder'
require 'selene/daylight_savings_time_builder'
require 'selene/event_builder'
require 'selene/feed_builder'
require 'selene/standard_time_builder'
require 'selene/time_zone_builder'
require 'selene/hash_with_multiple_values'

module Selene
  class Parser
    LINE_REGEX = %r/(?<name>[\w-]+)(?<params>(?:\;[\w-]+=(?:"[^"]*"\,?|[^\:\;])+)*)?:(?<value>.*)/
    PARAM_REGEX = %r/(?<key>[\w-]+)=(?<value>(?:"[^"]*"\,?|[^;])+)/

    NEWLINES = ["\r\n", "\r", "\n"].map(&:freeze)
    ENCODING = 'UTF-8'.freeze
    BEGIN_COMPONENT = 'BEGIN'.freeze
    END_COMPONENT = 'END'.freeze

    def self.parse(data)
      new(data).parse
    end

    def initialize(data)
      @io = data.is_a?(String) ? StringIO.new(data) : data
    end

    def parse
      stack = [builder('feed')]
      each_line do |line|
        if begin_component?(line)
          builder = builder(line.value)
          stack[-1].add(line, builder)
          stack << builder
        elsif end_component?(line)
          stack.pop
        else
          stack[-1].parse(line)
        end
      end
      pp stack[0].component
    end

    def builder(name)
      builder_class.fetch(name.upcase, ComponentBuilder).new(name)
    end

    def builder_class
      {
        'FEED' => FeedBuilder,
        'VCALENDAR' => CalendarBuilder,
        'VEVENT' => EventBuilder,
        'VTIMEZONE' => TimeZoneBuilder,
        'VALARM' => AlarmBuilder,
        'STANDARD' => StandardTimeBuilder,
        'DAYLIGHT' => DaylightSavingsTimeBuilder
      }
    end

    def begin_component?(line)
      line.name == 'BEGIN'
    end

    def end_component?(line)
      line.name == 'END'
    end

    def each_line(&block)
      enum = to_enum
      enum.each(&block) if block
      enum
    end

    def to_enum
      Enumerator.new do |yielder|
        folded = @io.read
        @io.rewind
        separator = folded[Regexp.union(NEWLINES)] || NEWLINES.first
        unfolded = folded.gsub("#{separator}\s", '').force_encoding(ENCODING)
        unfolded.each_line(separator).each_with_index do |line, index|
          puts "Line: #{line}"
          yielder << parse_line(line.chomp(separator), index)
        end
      end
    end

    def parse_line(line, index)
      line.match(LINE_REGEX) do |match|
        name = match[:name].upcase
        params = parse_params(match[:params])
        value = match[:value]
        Line.new(name, value, params, line: index + 1)
      end
    end

    def parse_params(params)
      params.to_s.scan(PARAM_REGEX).inject({}) do |memo, (key, value)|
        memo.merge(key => value)
      end
    end
  end
end
