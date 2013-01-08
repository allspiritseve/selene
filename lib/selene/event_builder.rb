module Selene
  class EventBuilder

    def initialize
      @component = Hash.new { |component, property| component[property] = [] }
    end

    def component
      @component
    end

    def parse(line)
      component[line.name.downcase] = case line.name
      when 'DTSTAMP', 'DTSTART', 'DTEND'
        line.value_with_params
      when 'GEO'
        line.value.split(';')
      else
        line.value
      end
    end

    def append(builder)
      case builder
      when AlarmBuilder
        @component['alarms'] << builder.component
      end
    end

  end
end
