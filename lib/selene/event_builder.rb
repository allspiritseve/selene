module Selene
  class EventBuilder

    def initialize
      @component = {}
    end

    def component
      @component
    end

    def parse(name, params, value)
      component[name.downcase] = case name
      when 'DTSTART', 'DTEND'
        params ? [value, params] : value
      when 'GEO'
        value.split(';')
      else
        value
      end
    end

  end
end
