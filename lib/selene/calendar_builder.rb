module Selene
  class CalendarBuilder

    PROPERTIES = %w(prodid version calscale method (x|iana)-.)

    def initialize
      @component = Hash.new { |h, attr| h[attr] = [] }
    end

    def parse(key, value)
      raise "Unknown calendar property #{key}" unless valid_property?(key)
      @component[key.downcase] = value
    end

    def valid_property?(name)
      PROPERTIES.any? { |p| name.downcase.match(p) }
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
