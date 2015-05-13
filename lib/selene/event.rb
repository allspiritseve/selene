module Selene
  class Component
    def initialize(properties = {})
      @properties = properties
    end

    def to_h
      @properties
    end

    def to_ical
    end
  end

  class Event < Component
    def initialize(properties = {})
    end

    def to_ical
      lines = []
      if @properties['exdate'] && @properties['exdate'].count > 0
        exdate_values = @exdate.map { |time| time.strftime('%Y%m%dT%H%M%S') }
        lines << "EXDATE;TZID=America/Detroit:#{exdate_values.join(',')}"
      end
      lines.join("\n")
    end
  end
end
