module Selene
  class DaylightSavingsTimeBuilder

    def initialize
      @component = {}
    end

    def component
      @component
    end

    def parse(line)
      @component[line[:name].downcase] = case line[:name]
      when 'RRULE' 
        Hash[line[:value].split(';').map { |vs| k, v = vs.split('=', 2); [k.downcase, v] }]
      else
        line[:value]
      end
    end
  end
end
