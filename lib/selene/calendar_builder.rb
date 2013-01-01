module Selene
  class CalendarBuilder

    def initialize
      @component = Hash.new { |component, property| component[property] = [] }
    end

    def parse(key, value)
      @component[key.downcase] = value
    end

    def append(builder)
      case builder
      when EventBuilder
        @component['events'] << builder.component
      when TimeZoneBuilder
        @component['time_zones'] << builder.component
      end
    end

    def component
      @component
    end
  end
end
