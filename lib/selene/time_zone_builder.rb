module Selene
  class TimeZoneBuilder

    def initialize
      @component = Hash.new { |component, property| component[property] = [] }
    end

    def component
      @component
    end

    def parse(name, params, value)
      @component[name.downcase] = value
    end

    def append(builder)
      case builder
      when DaylightSavingsTimeBuilder
        @component['daylight'] << builder.component
      end
    end

  end
end
