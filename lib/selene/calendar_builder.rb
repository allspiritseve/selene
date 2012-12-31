module Selene
  class CalendarBuilder
    attr_accessor :component

    def initialize
      self.component = Hash.new { |h, attr| h[attr] = [] }
    end

    def parse(key, value)
      component[key.downcase] = value
    end

    def append(builder)
      case builder
      when EventBuilder
        component['events'] << builder.component
      when TimeZoneBuilder
        component['time_zones'] << builder.component
      end
    end
  end
end
