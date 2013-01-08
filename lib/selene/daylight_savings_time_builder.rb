module Selene
  class DaylightSavingsTimeBuilder

    def initialize
      @component = {}
    end

    def component
      @component
    end

    def parse(line)
      @component[line.name] = case line.name
      when 'rrule'
        Hash[line.value.split(';').map { |vs| k, v = vs.split('=', 2); [k.downcase, v] }]
      else
        line.value
      end
    end
  end
end
