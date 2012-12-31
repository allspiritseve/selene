module Selene
  class TimeZoneBuilder
    attr_accessor :component

    def initialize
      self.component = Hash.new { |h, attr| h[attr] = [] }
    end

    def parse(key, value)
    end

    def append(builder)
      case builder
      when DaylightSavingsTimeBuilder
        append_daylight(builder.component)
      end
    end

    def append_daylight(daylight)
      component[:daylight] << daylight
    end
  end
end
