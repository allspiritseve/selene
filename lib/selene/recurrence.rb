require 'ostruct'
require 'selene/time_value'

module Selene
  class Recurrence
    DAYS = %w(MO TU WE TH FR SA SU)
    def initialize(options = {})
      rule.start_time = options.fetch(:dtstart)
      rule.frequency = options.fetch(:frequency)
      rule.count = options.fetch(:count, Float::INFINITY)
      rule.interval = options.fetch(:interval, 1)
      rule.end_time = options.fetch(:dtend, nil)
      rule.duration = options.fetch(:duration, nil)
      rule.until = options.fetch(:until, nil)
      rule.by_day = options.fetch(:by_day, []).map { |day| DAYS.index(day) + 1 }

      if rule.end_time
        rule.duration = rule.end_time - rule.start_time
      elsif rule.duration
        rule.end_time = rule.start_time + rule.duration
      end
    end

    def rule
      @rule ||= OpenStruct.new
    end

    def occurrences
      Enumerator.new do |yielder|
        1.upto(rule.count).inject(rule.start_time) do |start_time, n|
          break if n > rule.count
          break if start_time > rule.until if rule.until
          yielder << start_time
          if rule.by_day
            rule.by_day.each do |day|
              wday = start_time.time.wday
              offset = 7 + day - wday
              next_time = TimeValue.new(start_time).add(offset, :days)
            end
          end
          part = frequency_to_part(rule.frequency)
          TimeValue.new(start_time).add(rule.interval, part)
        end
      end
    end

    def add_time(time, interval, part)
      case part
      when :year then months_in_days(interval * 12, time)
      end
    end

    def add_years(time, years)
      time + months_to_days(time, years * 12)
    end

    def add_months(time, months)
      time + months_to_days(time, months)
    end

    def months_to_days(time, months)
      date = Date.new(time.year, time.month, time.day)
      (date >> months) - date
    end

    def frequency_to_part(frequency)
      case frequency.to_sym
      when :secondly then :second
      when :minutely then :minute
      when :hourly then :hour
      when :daily then :day
      when :weekly then :week
      when :monthly then :month
      when :yearly then :year
      else
        raise "Unknown frequency: #{frequency}"
      end
    end
  end
end
