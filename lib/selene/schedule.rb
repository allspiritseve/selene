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
        self.schedule = IceCube::Schedule.new(start_time, end_time: end_time)
      elsif duration
        self.schedule = IceCube::Schedule.new(start_time, duration: duration)
      end

      yield self if block_given?
    end

    private
    def schedule
      @schedule
    end

    def schedule=(new_schedule)
      @schedule = new_schedule
    end
  end
end
