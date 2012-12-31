module Selene
  class TimeZoneBuilder

    attr_accessor :component

    REQUIRED = %w(tzid)
    OPTIONAL = [/(x|iana)-./]
    SINGLE = %w(tzid last-modified tzurl)
    ONE_REQUIRED = [
      %w(standard daylight)
    ]

    PROPERTIES = REQUIRED + OPTIONAL + SINGLE + ONE_REQUIRED.flatten

    def initialize
      self.component = Hash.new { |h, attr| h[attr] = [] }
    end

    def parse(key, value)
      raise "Unknown time zone property #{key}" unless PROPERTIES.any? { |p| key.downcase.match(p) }
      component[key.downcase] = value
    end

    def valid?
      errors = {}
      REQUIRED.each do |property|
        errors[property] = "Missing required time zone property #{property}" unless component.keys.include?(property)
      end
      ONE_REQUIRED.each do |properties|
        errors[property] = "Missing required time zone properties #{properties.join(', ')}" unless properties.any? { |p| component.keys.include?(p) }
      end
      errors.empty?
    end

    def append(builder)
      case builder
      when DaylightSavingsTimeBuilder
        append_daylight(builder.component)
      end
    end

    def append_daylight(daylight)
      component['daylight'] << daylight
    end

  end
end
