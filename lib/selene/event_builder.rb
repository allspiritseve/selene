module Selene
  class EventBuilder

    def initialize
      @component = Hash.new { |component, property| component[property] = [] }
    end

    def component
      @component
    end

    def parse(line)
      component[line[:name].downcase] = case line[:name]
      when 'DTSTAMP', 'DTSTART', 'DTEND'
        Parser.parse_date_and_time(line)
      when 'GEO'
        line[:value].split(';')
      else
        line[:value]
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
