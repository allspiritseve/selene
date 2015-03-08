require 'byebug'

class TimeValue
  class UnknownPartError < StandardError
    attr_accessor :message

    def initialize(message)
      self.message = message
    end
  end

  attr_accessor :time

  def initialize(time)
    self.time = time
  end

  def add(num, part)
    time + in_seconds(num, part)
  end

  def subtract(num, type)
    add(-num, type)
  end

  def in_seconds(num, part = :seconds)
    case part
    when :year, :years then in_seconds(num * 12, :months)
    when :month, :months then in_seconds(months_as_days(num), :days)
    when :week, :weeks then in_seconds(num * 7, :days)
    when :day, :days then in_seconds(num * 24, :hours)
    when :hour, :hours then in_seconds(num * 60, :minutes)
    when :minute, :minutes then in_seconds(num * 60)
    when :second, :seconds then num
    else raise UnknownPartError, "Did not recognize '#{part}'"
    end
  end

  def months_as_days(months)
    date = time.to_date
    (date >> months) - date
  end
end
