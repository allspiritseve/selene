module Selene
  class CalendarBuilder

    def initialize
      @errors = []
      @component = Hash.new { |component, property| component[property] = [] }
    end

    def parse(line)
      set_property line.name, line.value
    end

    def set_property(name, value)
      @component[name.downcase] = value
    end

    def name(line)
      line.name.downcase
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
