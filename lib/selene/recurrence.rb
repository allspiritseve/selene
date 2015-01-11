require 'ostruct'
require 'selene/local_time'

module Selene
  class Recurrence
    def initialize(options = {})
      rule.start_time = options.fetch(:dtstart)
      rule.frequency = options.fetch(:frequency)
      rule.end_time = options.fetch(:dtend, nil)
      rule.duration = options.fetch(:duration, nil)
      rule.count = options.fetch(:count, Float::INFINITY)

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
        0.upto(rule.count).inject(LocalTime.from_time(rule.start_time)) do |local_start_time, n|
          break if n >= rule.count
          part = frequency_to_part(rule.frequency)
          next_local_time = local_start_time.add(n > 0 ? 1 : 0, part)
          yielder << next_local_time.to_time
          next_local_time
        end
      end
    end

    def frequency_to_part(frequency)
      case frequency.to_sym
      when :secondly then :sec
      when :minutely then :min
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
