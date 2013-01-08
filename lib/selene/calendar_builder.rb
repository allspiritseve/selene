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
      @errors << { :property => name, :message => "#{name} must not occur more than once http://tools.ietf.org/html/rfc5545#section-3.6" }
      @component[name] = value
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
