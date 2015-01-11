require 'ostruct'
require 'selene/local_time'

module Selene
  class Recurrence
    def initialize(options = {})
      rule.start_time = options.fetch(:dtstart)
      rule.frequency = options.fetch(:frequency)
      rule.count = options.fetch(:count, Float::INFINITY)
      rule.interval = options.fetch(:interval, 1)
      rule.end_time = options.fetch(:dtend, nil)
      rule.duration = options.fetch(:duration, nil)
      rule.until = options.fetch(:until, nil)

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
        0.upto(rule.count).inject(LocalTime.from_time(rule.start_time)) do |local_time, n|
          break if n > rule.count - 1
          break if local_time.to_time > rule.until if rule.until
          yielder << local_time.to_time
          part = frequency_to_part(rule.frequency)
          local_time.add(rule.interval, part)
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
