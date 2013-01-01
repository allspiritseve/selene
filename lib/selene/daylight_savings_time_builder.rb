module Selene
  class DaylightSavingsTimeBuilder

    def initialize
      @component = {}
    end

    def component
      @component
    end

    def parse(name, params, value)
      case name
      when 'RRULE' 
        @component[name.downcase] = Hash[value.split(';').map { |v| v.split('=') }.map { |k, v| [k.downcase, v] }]
      else
        @component[name.downcase] = value
      end
    end
  end
end
