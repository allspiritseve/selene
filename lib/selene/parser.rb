require 'selene/calendar_builder'

module Selene
  class Parser

    BUILDERS = {
      'VCALENDAR' => CalendarBuilder
    }

    LINE_BREAK = "\r\n"

    def self.parse(string)
      { :calendars => [] }.tap do |feed|
        stack = []
        unfold(string).split(LINE_BREAK).each_with_index do |line, i|
          key, value = line.split(':', 2)
          if key.upcase == 'BEGIN'
            stack << BUILDERS[value].new
          elsif key.upcase == 'END'
            builder = stack.pop
            if !stack.empty?
              stack[-1].append(builder)
            else
              feed[:calendars] << builder.component
            end
          else
            stack[-1].parse(key, value)
          end
        end
      end
    end

    def self.unfold(string)
      string.gsub(/#{LINE_BREAK}\s/, '')
    end
  end
end
