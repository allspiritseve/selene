module Selene
  class Schedule
    attr_accessor :start_time, :end_time, :duration, :count

    class InvalidScheduleError < StandardError
    end

    def initialize(start_time, options = {})
      self.start_time = start_time
      self.end_time = options.fetch(:end_time, nil)
      self.duration = options.fetch(:duration, nil)
      self.count = options.fetch(:count, Float::INFINITY)

      if end_time
        self.duration = end_time - start_time
      elsif duration
        self.end_time = start_time + duration
      end

      yield self if block_given?
    end

    def occurrences
      Enumerator.new do |yielder|
        1.upto(count).inject(start_time) do |start, n|
          next_time = start + 60 * 60
          yielder << next_time
          next_time
        end
      end
    end
  end
end
