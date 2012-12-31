module Selene
  class CalendarBuilder
    attr_accessor :component

    def initialize
      self.component = {}
    end

    def parse(key, value)
      component[key.downcase] = value
    end

    def append(builder)
      case builder
      when TimeZoneBuilder
      end
    end
  end
end
