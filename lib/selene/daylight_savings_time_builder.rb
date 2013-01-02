module Selene
  class DaylightSavingsTimeBuilder

    def initialize
      @component = {}
    end

    def component
      @component
    end

    def parse(name, params, value)
      @component[name.downcase] = case name
      when 'RRULE' 
        Hash[value.split(';').map { |vs| k, v = vs.split('=', 2); [k.downcase, v] }]
      else
        value
      end
    end
  end
end
