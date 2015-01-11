require 'byebug'

class LocalTime < Struct.new(:year, :month, :day, :hour, :min, :sec)
  class UnknownPart < StandardError
    attr_accessor :message

    def initialize(message)
      self.message = message
    end
  end

  def self.from_time(time)
    new(*members.map { |member| time.send(member) })
  end

  def self.in_seconds(num, part)
    case part
    when :week, :weeks then in_seconds(num * 7, :days)
    when :day, :days then in_seconds(num * 24, :hours)
    when :hour, :hours then in_seconds(num * 60, :minutes)
    when :min, :mins, :minute, :minutes then in_seconds(num * 60, :seconds)
    when :sec, :secs, :second, :seconds then num
    else
      raise "Cannot determine precise number of seconds for [#{num}, #{part}]"
    end
  end

  def self.num_in_range(num, range)
    if range.cover?(num)
      num
    elsif num > range.max
      range.max
    else
      range.min
    end
  end

  def self.num_modulo_range(num, range)
    if range.cover?(num)
      0
    elsif num > range.max
      num - range.max
    else
      num - range.min
    end
  end

  def self.num_cycle_range(num, range)
    ((num + range.max) - range.min) % range.max + range.min
  end

  def self.num_cycle_offset_range(num, range)
    if range.cover?(num)
      0
    elsif num > range.max
      num / range.max
    else
      (num - 1) / range.max
    end
  end

  def initialize(*parts)
    super(*0.upto(5).map { |n| parts.fetch(n, 0) })
  end

  def add(num, part)
    validate_part(part)
    parts = members.map do |member|
      if member == part
        send(member) + num
      elsif member == :day && part == :week
        day + (num * 7)
      else
        send(member)
      end
    end

    LocalTime.new(*parts)
  end

  def subtract(num, type)
    add(-num, type)
  end

  def to_time
    Time.new(year + num_cycle_offset_range(month, 1..12), num_cycle_range(month, 1..12), num_in_range(day, 1..31), num_in_range(hour, 1..24), num_in_range(min, 1..60), num_in_range(sec, 1..60)) +
      in_seconds(num_modulo_range(day, 1..31), :days) +
      in_seconds(num_modulo_range(hour, 1..24), :hours) +
      in_seconds(num_modulo_range(min, 1..60), :minutes) +
      in_seconds(num_modulo_range(sec, 1..60), :seconds)
  end

  def in_seconds(num, part)
    self.class.in_seconds(num, part)
  end

  def num_in_range(num, range)
    self.class.num_in_range(num, range)
  end

  def num_modulo_range(num, range)
    self.class.num_modulo_range(num, range)
  end

  def num_cycle_range(num, range)
    self.class.num_cycle_range(num, range)
  end

  def num_cycle_offset_range(num, range)
    self.class.num_cycle_offset_range(num, range)
  end

  def validate_part(part)
    valid_parts = members + [:week]
    raise UnknownPart, "Did not recognize '#{part}'" unless valid_parts.include?(part)
  end
end
