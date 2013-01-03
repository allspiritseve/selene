module Selene
  class EventBuilder

    def initialize
      @component = Hash.new { |component, property| component[property] = [] }
    end

    def component
      @component
    end

    def parse(name, params, value)
      component[name.downcase] = case name
      when 'DTSTAMP', 'DTSTART', 'DTEND'
        Parser.parse_date_and_time(name, params, value)
      when 'GEO'
        value.split(';')
      else
        value
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
