module Selene
  class TimeZoneBuilder

    attr_accessor :component

    # Is this the best way to specify these rules?
    REQUIRED = %w(tzid)
    OPTIONAL = [/(x|iana)-./]
    SINGLE = %w(tzid last-modified tzurl)
    ONE_REQUIRED = [
      %w(standard daylight)
    ]

    PROPERTIES = %w(tzid tzurl standard daylight last-modified (x|iana)-.)

    def initialize
      self.component = Hash.new { |h, attr| h[attr] = [] }
    end

    def parse(key, value)
      raise "Unknown time zone property #{key}" unless valid_property?(key)
      component[key.downcase] = value
    end

    def valid_property?(name)
      PROPERTIES.any? { |p| name.downcase.match(p) }
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
